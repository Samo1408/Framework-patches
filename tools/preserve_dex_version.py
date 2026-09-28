#!/usr/bin/env python3
import hashlib
import struct
import sys
import zlib
from pathlib import Path

if len(sys.argv) != 3:
    print(f"usage: {sys.argv[0]} DEX_FILE VERSION", file=sys.stderr)
    sys.exit(2)

path = Path(sys.argv[1])
version = sys.argv[2]
if len(version) != 3 or not version.isdigit():
    print("VERSION must be a 3-digit DEX version such as 039", file=sys.stderr)
    sys.exit(2)

data = bytearray(path.read_bytes())
if len(data) < 32 or data[:4] != b"dex\n":
    print(f"Not a valid DEX: {path}", file=sys.stderr)
    sys.exit(3)

old = data[4:7].decode("ascii", "replace")
new_magic = b"dex\n" + version.encode("ascii") + b"\x00"
data[:8] = new_magic

# DEX signature = SHA-1 of all bytes after the signature field (offset 32).
data[12:32] = hashlib.sha1(data[32:]).digest()
# DEX checksum = Adler-32 of all bytes after the checksum field (offset 12).
data[8:12] = struct.pack("<I", zlib.adler32(data[12:]) & 0xffffffff)

path.write_bytes(data)
print(f"{path.name}: DEX {old} -> {version}; signature/checksum recalculated")
