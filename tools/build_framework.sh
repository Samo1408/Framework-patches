#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
INPUT="${1:-$ROOT/framework.jar}"
OUTPUT="${2:-$ROOT/framework_A14_universal_sim-cached_patched.jar}"
# Always use an absolute output path. The JAR must be written outside WORK/jar,
# otherwise zip would try to include the output JAR while creating it.
if [[ "$OUTPUT" != /* ]]; then
  OUTPUT="$(cd "$(dirname "$OUTPUT")" && pwd)/$(basename "$OUTPUT")"
fi
BAKSMALI_JAR="${BAKSMALI_JAR:-$ROOT/tools/baksmali-3.0.10-fat.jar}"
SMALI_JAR="${SMALI_JAR:-$ROOT/tools/smali-3.0.10-fat.jar}"
API="${API:-34}"

[[ -f "$INPUT" ]] || { echo "Missing input framework.jar: $INPUT" >&2; exit 2; }
[[ -f "$BAKSMALI_JAR" ]] || { echo "Missing $BAKSMALI_JAR" >&2; exit 2; }
[[ -f "$SMALI_JAR" ]] || { echo "Missing $SMALI_JAR" >&2; exit 2; }

if [[ -n "${WORK_DIR:-}" ]]; then
  WORK="$WORK_DIR"
  rm -rf "$WORK"
  mkdir -p "$WORK"
  KEEP_WORK=1
else
  WORK="$(mktemp -d)"
  KEEP_WORK="${KEEP_WORK:-0}"
fi
trap 'status=$?; if [[ "$KEEP_WORK" != "1" ]]; then rm -rf "$WORK"; fi; exit "$status"' EXIT
mkdir -p "$WORK/jar" "$WORK/original_dex" "$WORK/dex" "$WORK/out" "$WORK/logs"

SMALI_XMX="${SMALI_XMX:-6g}"
SMALI_JAVA_OPTS="${SMALI_JAVA_OPTS:--Xmx$SMALI_XMX -XX:+UseSerialGC}"

unzip -q "$INPUT" -d "$WORK/jar"
mapfile -t DEXES < <(find "$WORK/jar" -maxdepth 1 -type f -name 'classes*.dex' -printf '%f\n' | sort -V)
(( ${#DEXES[@]} > 0 )) || { echo "No classes*.dex found" >&2; exit 3; }
cp "$WORK/jar"/classes*.dex "$WORK/original_dex/"

for dex in "${DEXES[@]}"; do
  name="${dex%.dex}"
  java -jar "$BAKSMALI_JAR" disassemble --api "$API" --output "$WORK/dex/$name" "$WORK/jar/$dex"
done

# Universal patching: locate framework classes by descriptor, then replace only
# methods that are part of this project's spoof surface. This avoids assumptions
# about classesN.dex placement and preserves vendor-specific methods/fields.
PATCHER="$ROOT/tools/universal_patch.py"
[[ -f "$PATCHER" ]] || { echo "Missing $PATCHER" >&2; exit 4; }
PATCH_REPORT="$WORK/logs/universal-patch.json"
python3 "$PATCHER" \
  --dex-root "$WORK/dex" \
  --patch-root "$ROOT/patches" \
  --report "$PATCH_REPORT" | tee "$WORK/logs/universal-patch.log"

# Require every functional target class to have at least one matching method.
# A missing individual method is tolerated because Samsung can remove/rename
# implementation details between One UI 6.x builds; a completely untouched
# target class, however, would mean the requested feature is absent.
python3 - "$PATCH_REPORT" <<'PY'
import json, sys
p=json.load(open(sys.argv[1]))
for r in p['results']:
    if r['status'] != 'patched':
        raise SystemExit(f"Universal patch did not modify {r['target']}: {r['status']}")
print(f"Universal patch applied methods: {p['patched_methods']}")
PY

# Add helper classes to the DEX that contains their primary target class.
# Cross-DEX references are valid, while co-locating the helper keeps the
# framework layout close to the original project where possible.
# Resolve the actual DEX root directory from a class path.  The first path
# component below $WORK/dex is the real DEX name (classes, classes2, ...).
class_dex_dir() {
  local rel="$1"
  local hit relpath dexname
  hit="$(find "$WORK/dex" -type f -path "*/$rel" -print -quit)"
  [[ -n "$hit" ]] || return 1
  relpath="${hit#"$WORK/dex/"}"
  dexname="${relpath%%/*}"
  printf '%s/%s' "$WORK/dex" "$dexname"
}

BUILD_DEX_DIR="$(class_dex_dir android/os/Build.smali)"
LOCATION_DEX_DIR="$(class_dex_dir android/location/Location.smali)"
[[ -n "$BUILD_DEX_DIR" && -d "$BUILD_DEX_DIR" ]] || { echo "Cannot locate Build.smali after universal patch" >&2; exit 6; }
[[ -n "$LOCATION_DEX_DIR" && -d "$LOCATION_DEX_DIR" ]] || { echo "Cannot locate Location.smali after universal patch" >&2; exit 6; }

mkdir -p "$BUILD_DEX_DIR/android/os" "$LOCATION_DEX_DIR/android/location"
cp "$ROOT/patches/android/os/BuildSpoof.smali" "$BUILD_DEX_DIR/android/os/BuildSpoof.smali"
cp "$ROOT/patches/android/location/Spoof.smali" "$LOCATION_DEX_DIR/android/location/Spoof.smali"
echo "BuildSpoof -> $(basename "$BUILD_DEX_DIR").dex"
echo "Location/SIM Spoof -> $(basename "$LOCATION_DEX_DIR").dex"

# Only DEX files containing patched classes/helpers need to be reassembled.
# Untouched DEX files are kept byte-for-byte from the original framework.jar.
# This is important for Samsung framework DEX files that are valid on-device
# but cannot be losslessly round-tripped through smali (e.g. near the 65K
# reference limit).
mapfile -t MODIFIED_DEXES < <(
  python3 - "$PATCH_REPORT" "$BUILD_DEX_DIR" "$LOCATION_DEX_DIR" <<'PY'
import json, sys
from pathlib import Path
p=json.load(open(sys.argv[1], encoding='utf-8'))
seen=set()
for r in p.get('results', []):
    if r.get('status') == 'patched' and r.get('dex'):
        seen.add(r['dex'] + '.dex')
for d in sys.argv[2:4]:
    seen.add(Path(d).name + '.dex')
for x in sorted(seen):
    print(x)
PY
)
(( ${#MODIFIED_DEXES[@]} > 0 )) || { echo "No modified DEX files found" >&2; exit 9; }

echo "Modified DEX files: ${MODIFIED_DEXES[*]}"
echo "Untouched DEX files will be preserved byte-for-byte."

# Samsung framework DEX files can sit above the 65,535 string-id boundary.
# Adding our helper classes shifts string indices, so an existing const-string
# can become an index such as 65548. DEX provides const-string/jumbo exactly
# for this case. Normalize all const-string instructions in modified DEX trees
# before assembly; jumbo is valid for both low and high string indices and does
# not change the runtime value or method semantics.
for dex in "${MODIFIED_DEXES[@]}"; do
  name="${dex%.dex}"
  DEX_SRC="$WORK/dex/$name"
  python3 - "$DEX_SRC" <<'PY'
from pathlib import Path
import sys
root = Path(sys.argv[1])
changed = 0
for p in root.rglob('*.smali'):
    try:
        text = p.read_text(encoding='utf-8')
    except UnicodeDecodeError:
        continue
    lines = text.splitlines(keepends=True)
    out = []
    local = 0
    for line in lines:
        stripped = line.lstrip()
        indent = line[:len(line)-len(stripped)]
        if stripped.startswith('const-string ') and not stripped.startswith('const-string/jumbo '):
            line = indent + stripped.replace('const-string ', 'const-string/jumbo ', 1)
            local += 1
        out.append(line)
    if local:
        p.write_text(''.join(out), encoding='utf-8')
        changed += local
print(f"Jumbo-normalized {changed} const-string instructions in {root.name}.dex")
PY
done

# First try normal round-trip assembly. If a Samsung DEX cannot be
# round-tripped because its global reference tables are already at a 16-bit
# boundary, fall back to an overlay DEX containing only the patched classes.
# The original DEX is then shifted later in the multi-dex sequence and remains
# byte-for-byte unchanged. This avoids rewriting unrelated vendor classes.
OVERLAY_ROOT="$WORK/overlays"
mkdir -p "$OVERLAY_ROOT"
declare -a OVERLAY_NAMES=()

for dex in "${MODIFIED_DEXES[@]}"; do
  name="${dex%.dex}"
  log="$WORK/logs/assemble-$name.log"
  echo "=== ASSEMBLING MODIFIED $dex ==="
  set +e
  java $SMALI_JAVA_OPTS -jar "$SMALI_JAR" assemble --api "$API" --output "$WORK/jar/$dex" "$WORK/dex/$name" >"$log" 2>&1
  rc=$?
  set -e
  cat "$log"
  if [[ "$rc" -eq 0 && -s "$WORK/jar/$dex" ]]; then
    echo "=== ASSEMBLED $dex ==="
    continue
  fi

  echo "=== ROUND-TRIP FAILED FOR $dex; BUILDING CLASS OVERLAY ==="
  rm -f "$WORK/jar/$dex"
  overlay="$OVERLAY_ROOT/$name"
  rm -rf "$overlay"
  mkdir -p "$overlay"

  # Copy only classes actually modified by the universal patcher.
  python3 - "$PATCH_REPORT" "$name" "$WORK/dex/$name" "$overlay" "$ROOT/patches" <<'PY'
import json, shutil, sys
from pathlib import Path
report=json.load(open(sys.argv[1],encoding='utf-8'))
dex=sys.argv[2]
src=Path(sys.argv[3]); dst=Path(sys.argv[4]); patchroot=Path(sys.argv[5])
targets=[]
for r in report.get("results",[]):
    if r.get("status")=="patched" and r.get("dex")==dex:
        targets.append(r["target"])
for rel in targets:
    p=src/rel
    if not p.is_file():
        raise SystemExit(f"Missing patched class for overlay: {p}")
    q=dst/rel; q.parent.mkdir(parents=True,exist_ok=True)
    shutil.copy2(p,q)
# Helpers referenced by the patched methods.
for rel in ("android/os/BuildSpoof.smali","android/location/Spoof.smali"):
    p=patchroot/rel
    if p.is_file():
        q=dst/rel; q.parent.mkdir(parents=True,exist_ok=True)
        shutil.copy2(p,q)
print("Overlay classes:", ", ".join(targets))
PY

  overlay_dex="$OVERLAY_ROOT/${name}.dex"
  java $SMALI_JAVA_OPTS -jar "$SMALI_JAR" assemble --api "$API" --output "$overlay_dex" "$overlay" >"$WORK/logs/overlay-$name.log" 2>&1
  cat "$WORK/logs/overlay-$name.log"
  test -s "$overlay_dex" || { echo "ERROR: overlay assembly failed for $dex" >&2; exit "$rc"; }
  OVERLAY_NAMES+=("$name")
done

# Build the final multi-dex set. Normal modified DEXs use their original
# positions. Failed round-trip DEXs are replaced by an overlay at their
# original position; their untouched original bytes are shifted after it.
# Android's class lookup uses the first definition, so the overlay wins.
FINAL_DIR="$WORK/finaljar"
rm -rf "$FINAL_DIR"; mkdir -p "$FINAL_DIR"
for f in "$WORK/jar"/*; do
  [[ -f "$f" ]] || continue
  cp -p "$f" "$FINAL_DIR/$(basename "$f")"
done

# Track original DEX names and insert overlays by shifting the original DEX
# and every later DEX one slot. This keeps classes.dex/classes2.dex sequencing.
declare -A OVERLAY_FOR
for name in "${OVERLAY_NAMES[@]}"; do OVERLAY_FOR["$name"]=1; done

if (( ${#OVERLAY_NAMES[@]} > 0 )); then
  rm -f "$FINAL_DIR"/classes*.dex
  output_index=0
  for orig in "${DEXES[@]}"; do
    oname="${orig%.dex}"
    outdex=""
    if [[ "${OVERLAY_FOR[$oname]:-0}" == "1" ]]; then
      outdex="classes.dex"
      (( output_index > 0 )) && outdex="classes$((output_index+1)).dex"
      cp -p "$OVERLAY_ROOT/$oname.dex" "$FINAL_DIR/$outdex"
      output_index=$((output_index+1))
      outdex="classes.dex"
      (( output_index > 0 )) && outdex="classes$((output_index+1)).dex"
      cp -p "$WORK/original_dex/$orig" "$FINAL_DIR/$outdex"
      output_index=$((output_index+1))
    else
      outdex="classes.dex"
      (( output_index > 0 )) && outdex="classes$((output_index+1)).dex"
      cp -p "$WORK/jar/$orig" "$FINAL_DIR/$outdex"
      output_index=$((output_index+1))
    fi
  done
fi

# Switch final packaging source to FINAL_DIR.
rm -rf "$WORK/jar"
mv "$FINAL_DIR" "$WORK/jar"

# Preserve the requested DEX 039 format for modified DEX files only.
DEX_VERSION_TOOL="$ROOT/tools/preserve_dex_version.py"
[[ -f "$DEX_VERSION_TOOL" ]] || { echo "Missing $DEX_VERSION_TOOL" >&2; exit 8; }

for dex in "$WORK"/jar/classes*.dex; do
  [[ -f "$dex" ]] || continue
  python3 "$DEX_VERSION_TOOL" "$dex" 039
done

# Modified JARs must not retain stale signing metadata.
rm -f "$WORK/jar/META-INF/ANDROID.RSA" "$WORK/jar/META-INF/ANDROID.SF" "$WORK/jar/META-INF/SIG-*"
rm -f "$WORK/jar/META-INF"/*.SF "$WORK/jar/META-INF"/*.RSA "$WORK/jar/META-INF"/*.DSA

mkdir -p "$(dirname "$OUTPUT")"
rm -f "$OUTPUT"
# Write the final archive outside WORK/jar so it cannot include itself.
(cd "$WORK/jar" && zip -q -X -r "$OUTPUT" .)

# Structural checks.
unzip -t "$OUTPUT" >/dev/null
count=$(unzip -l "$OUTPUT" | awk '/classes[0-9]*\.dex$/ {n++} END {print n+0}')
[[ "$count" -eq "${#DEXES[@]}" ]] || { echo "DEX count changed: $count != ${#DEXES[@]}" >&2; exit 7; }

echo "Built: $OUTPUT"
echo "DEX count preserved: $count"
