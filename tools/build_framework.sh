#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
INPUT="${1:-$ROOT/framework.jar}"
OUTPUT="${2:-$ROOT/framework_A14_sim-cached_patched.jar}"
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

copy_patch() {
  local rel="$1"
  local src="$ROOT/patches/$rel"
  local dst=""
  [[ -f "$src" ]] || { echo "Missing patch: $src" >&2; exit 4; }
  dst="$(find "$WORK/dex" -type f -path "*/$rel" -print -quit || true)"
  if [[ -n "$dst" ]]; then
    cp "$src" "$dst"
    echo "patched existing: $rel -> $dst"
  else
    echo "ERROR: target class not found in original DEXs: $rel" >&2
    exit 5
  fi
}

# Apply every patched class that must replace an existing framework class.
# BuildSpoof is handled separately because it is a new runtime class.
copy_patch android/location/Country.smali
copy_patch android/location/Location.smali
copy_patch android/telephony/SubscriptionInfo.smali
copy_patch android/telephony/TelephonyManager.smali
copy_patch android/os/Build.smali
copy_patch 'android/os/Build$VERSION.smali'

# New runtime classes are deliberately kept in their original target DEX boundaries.
[[ -d "$WORK/dex/classes3" ]] || { echo "classes3.dex is required for BuildSpoof" >&2; exit 6; }
[[ -d "$WORK/dex/classes6" ]] || { echo "classes6.dex is required for Spoof" >&2; exit 6; }
mkdir -p "$WORK/dex/classes3/android/os" "$WORK/dex/classes6/android/location"
cp "$ROOT/patches/android/os/BuildSpoof.smali" "$WORK/dex/classes3/android/os/BuildSpoof.smali"
cp "$ROOT/patches/android/location/Spoof.smali" "$WORK/dex/classes6/android/location/Spoof.smali"

# Static contract checks: the patched framework must actually reference the runtime reader.
grep -q 'Landroid/os/BuildSpoof;->get(Ljava/lang/String;)Ljava/lang/String;' "$ROOT/patches/android/os/Build.smali" \
  || { echo "ERROR: Build.smali is not wired to BuildSpoof.get" >&2; exit 10; }
grep -q 'Landroid/os/BuildSpoof;->getInt(Ljava/lang/String;I)I' "$ROOT/patches/android/os/Build\$VERSION.smali" \
  || { echo "ERROR: Build$VERSION.smali is not wired to BuildSpoof.getInt" >&2; exit 10; }
grep -q 'Landroid/os/BuildSpoof;->getBoolean(Ljava/lang/String;Z)Z' "$ROOT/patches/android/os/Build.smali" \
  || { echo "ERROR: Build.smali is not wired to BuildSpoof.getBoolean" >&2; exit 10; }
grep -q 'Landroid/os/BuildSpoof;->getSerialNumber()Ljava/lang/String;' "$ROOT/patches/android/os/Build.smali" \
  || { echo "ERROR: Build.smali serial path is not wired to BuildSpoof" >&2; exit 10; }

# Hard fail if any expected patched/new class is missing before assembly.
for expected in \
  "$WORK/dex/classes3/android/os/BuildSpoof.smali" \
  "$WORK/dex/classes6/android/location/Spoof.smali"; do
  [[ -f "$expected" ]] || { echo "ERROR: expected injected class missing: $expected" >&2; exit 9; }
done

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
