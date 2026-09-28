#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
B="$ROOT/patches/android/os/Build.smali"
V="$ROOT/patches/android/os/Build\$VERSION.smali"
S="$ROOT/patches/android/os/BuildSpoof.smali"
for f in "$B" "$V" "$S"; do test -s "$f" || { echo "Missing: $f" >&2; exit 2; }; done

grep -q 'Landroid/os/BuildSpoof;->get(Ljava/lang/String;)Ljava/lang/String;' "$B"
grep -q 'Landroid/os/BuildSpoof;->getInt(Ljava/lang/String;I)I' "$B"
grep -q 'Landroid/os/BuildSpoof;->getBoolean(Ljava/lang/String;Z)Z' "$B"
grep -q 'Landroid/os/BuildSpoof;->getSerialNumber()Ljava/lang/String;' "$B"
grep -q 'Landroid/os/BuildSpoof;->getInt(Ljava/lang/String;I)I' "$V"
grep -q 'Landroid/os/Build;->-\$\$Nest\$smgetString(Ljava/lang/String;)Ljava/lang/String;' "$V"
grep -q '"/data/build.prop"' "$S"
grep -q 'sLastModified' "$S" 2>/dev/null || true
# Ensure the old one-shot loader was not retained.
if grep -q 'sput-boolean v0, Landroid/os/BuildSpoof;->sLoaded:Z' "$S" && ! grep -q 'sLastModified' "$S"; then
  echo 'ERROR: stale one-shot loader detected' >&2; exit 3
fi
printf '%s\n' 'BuildSpoof static verification: OK'
