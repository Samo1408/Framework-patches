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
BAKSMALI_JAR="${BAKSMALI_JAR:-$ROOT/tools/baksmali-3.0.9-fat.jar}"
SMALI_JAR="${SMALI_JAR:-$ROOT/tools/smali-3.0.9-fat.jar}"
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
mkdir -p "$WORK/jar" "$WORK/dex" "$WORK/out" "$WORK/logs"

SMALI_XMX="${SMALI_XMX:-6g}"
SMALI_JAVA_OPTS="${SMALI_JAVA_OPTS:--Xmx$SMALI_XMX -XX:+UseSerialGC}"

unzip -q "$INPUT" -d "$WORK/jar"
mapfile -t DEXES < <(find "$WORK/jar" -maxdepth 1 -type f -name 'classes*.dex' -printf '%f\n' | sort -V)
(( ${#DEXES[@]} > 0 )) || { echo "No classes*.dex found" >&2; exit 3; }

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
class_dir() {
  local rel="$1"
  find "$WORK/dex" -type f -path "*/$rel" -print -quit | xargs -r dirname
}

BUILD_DIR="$(class_dir android/os/Build.smali)"
LOCATION_DIR="$(class_dir android/location/Location.smali)"
[[ -n "$BUILD_DIR" && -d "$BUILD_DIR" ]] || { echo "Cannot locate Build.smali after universal patch" >&2; exit 6; }
[[ -n "$LOCATION_DIR" && -d "$LOCATION_DIR" ]] || { echo "Cannot locate Location.smali after universal patch" >&2; exit 6; }

BUILD_DEX_DIR="$(dirname "$BUILD_DIR")"
LOCATION_DEX_DIR="$(dirname "$LOCATION_DIR")"
mkdir -p "$BUILD_DEX_DIR/android/os" "$LOCATION_DEX_DIR/android/location"
cp "$ROOT/patches/android/os/BuildSpoof.smali" "$BUILD_DEX_DIR/android/os/BuildSpoof.smali"
cp "$ROOT/patches/android/location/Spoof.smali" "$LOCATION_DEX_DIR/android/location/Spoof.smali"
echo "BuildSpoof -> $(basename "$BUILD_DEX_DIR").dex"
echo "Location/SIM Spoof -> $(basename "$LOCATION_DEX_DIR").dex"

rm -f "$WORK/jar"/classes*.dex
for dex in "${DEXES[@]}"; do
  name="${dex%.dex}"
  log="$WORK/logs/assemble-$name.log"
  echo "=== ASSEMBLING $dex ==="
  echo "Java: $(java -version 2>&1 | head -1)"
  echo "Heap: $SMALI_XMX"
  echo "Source: $WORK/dex/$name"
  echo "Output: $WORK/jar/$dex"
  set +e
  java $SMALI_JAVA_OPTS -jar "$SMALI_JAR" assemble --api "$API" --output "$WORK/jar/$dex" "$WORK/dex/$name" >"$log" 2>&1
  rc=$?
  set -e
  cat "$log"
  if [[ "$rc" -ne 0 ]]; then
    echo "ERROR: smali assemble failed for $dex with exit code $rc" >&2
    echo "Diagnostic log: $log" >&2
    if command -v free >/dev/null 2>&1; then free -h >&2 || true; fi
    if [[ -r /proc/meminfo ]]; then grep -E 'Mem(Total|Free|Available)|Swap(Total|Free)' /proc/meminfo >&2 || true; fi
    exit "$rc"
  fi
  test -s "$WORK/jar/$dex"
  echo "=== ASSEMBLED $dex: $(stat -c '%s bytes' "$WORK/jar/$dex") ==="
done

# Preserve the requested DEX 039 format for MT Manager compatibility.
# smali 3.0.9 may emit DEX 040 when assembling API 34 sources; normalize
# the generated DEX header to 039 and recalculate both integrity fields.
# ZIP compression is intentionally unchanged: the final JAR remains a normal
# compressed ZIP archive to keep its size lower than the original framework.
DEX_VERSION_TOOL="$ROOT/tools/preserve_dex_version.py"
[[ -f "$DEX_VERSION_TOOL" ]] || { echo "Missing $DEX_VERSION_TOOL" >&2; exit 8; }

for dex in "${DEXES[@]}"; do
  python3 "$DEX_VERSION_TOOL" "$WORK/jar/$dex" 039
  echo "=== DEX VERSION $dex: $(python3 -c 'import sys; print(open(sys.argv[1],"rb").read(8)[4:7].decode("ascii"))' "$WORK/jar/$dex") ==="
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
