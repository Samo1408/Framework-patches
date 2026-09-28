#!/usr/bin/env python3
"""Reject framework JARs that do not match this Android 14 patch layout."""

from __future__ import annotations

import argparse
from pathlib import Path
from zipfile import BadZipFile, ZipFile


REQUIRED_DEX = ("classes.dex", "classes2.dex", "classes3.dex", "classes4.dex", "classes5.dex", "classes6.dex")
CLASS3_MARKERS = (
    b"Landroid/os/Build;",
    b"Landroid/os/Build$VERSION;",
    b"Landroid/os/SemSystemProperties;",
)
ALL_MARKERS = (
    *CLASS3_MARKERS,
    b"Landroid/telephony/TelephonyManager;",
    b"Landroid/location/Location;",
)


def require(condition: bool, message: str) -> None:
    if not condition:
        raise ValueError(message)


def inspect(path: Path, for_patching: bool, patched_output: bool) -> str:
    require(path.is_file(), f"Missing framework JAR: {path}")
    try:
        with ZipFile(path) as archive:
            require(archive.testzip() is None, "framework JAR contains a corrupt ZIP member")
            names = set(archive.namelist())
            missing = [name for name in REQUIRED_DEX if name not in names]
            require(not missing, "Expected Android 14 six-DEX layout; missing " + ", ".join(missing))
            dexes = {name: archive.read(name) for name in REQUIRED_DEX}
    except BadZipFile as error:
        raise ValueError(f"Invalid framework JAR ZIP: {error}") from error

    for name, data in dexes.items():
        require(data[:4] == b"dex\n", f"{name} is not a DEX file")
        require(data[4:7] == b"039", f"{name} has DEX {data[4:7]!r}; expected DEX 039")
    for marker in CLASS3_MARKERS:
        require(marker in dexes["classes3.dex"], f"classes3.dex lacks {marker.decode('ascii')}")
    joined = b"".join(dexes.values())
    for marker in ALL_MARKERS:
        require(marker in joined, f"Framework lacks expected class {marker.decode('ascii')}")

    installed = b"Landroid/os/BuildSpoof;" in dexes["classes3.dex"]
    if patched_output:
        require(installed, "patched output lacks BuildSpoof in classes3.dex")
        for marker in (b"/data/system/devicespoof/build.prop", b"ro.soc.manufacturer", b"ro.soc.model",
                       b"devicespoof.operator.numeric"):
            require(marker in b"".join(dexes.values()),
                    f"patched output lacks required override marker {marker.decode('ascii')}")
        return "Patched framework output has the required overlay and Country markers."
    if for_patching:
        return "Framework layout is compatible for patching" + (" (existing BuildSpoof will be replaced)." if installed else ".")
    return "Framework layout is compatible; BuildSpoof is " + ("present." if installed else "not present.")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("framework_jar", type=Path)
    parser.add_argument("--for-patching", action="store_true")
    parser.add_argument("--patched-output", action="store_true",
                        help="require markers that must exist after this project's patches are assembled")
    args = parser.parse_args()
    try:
        print(inspect(args.framework_jar, args.for_patching, args.patched_output))
        return 0
    except ValueError as error:
        print(f"Framework compatibility: FAILED: {error}")
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
