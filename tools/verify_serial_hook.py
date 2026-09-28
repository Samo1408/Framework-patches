#!/usr/bin/env python3
"""Structural checks for the serial-number override wiring."""

from pathlib import Path
import sys


ROOT = Path(__file__).resolve().parents[1]


def method_body(path: Path, signature: str) -> str:
    content = path.read_text(encoding="utf-8")
    start = content.find(signature)
    if start == -1:
        raise AssertionError(f"Missing method: {path}: {signature}")
    end = content.find(".end method", start)
    if end == -1:
        raise AssertionError(f"Unterminated method: {path}: {signature}")
    return content[start:end]


def require(text: str, expected: str, description: str) -> None:
    if expected not in text:
        raise AssertionError(f"Missing {description}: {expected}")


def main() -> int:
    build_spoof = ROOT / "patches/android/os/BuildSpoof.smali"
    sem_properties = ROOT / "patches/android/os/SemSystemProperties.smali"
    build = ROOT / "patches/android/os/Build.smali"

    serial_helper = method_body(build_spoof, ".method public static declared-synchronized getSerialNumber()")
    require(serial_helper, 'const-string v0, "serialNumber"', "preferred serialNumber key")
    require(serial_helper, 'const-string v0, "serialnumber"', "legacy serialnumber key")
    require(serial_helper, "if-nez v1, :cond_none", "empty-value rejection")

    device_serial = method_body(sem_properties, ".method public static blacklist getDeviceSerialNumber()")
    require(device_serial, "BuildSpoof;->getSerialNumber()Ljava/lang/String;", "device serial hook")
    require(device_serial, "move-result-object v0", "device serial hook result")
    require(device_serial, "SemSystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;", "shared fallback path")

    for signature in (
        ".method public static whitelist get(Ljava/lang/String;)Ljava/lang/String;",
        ".method public static whitelist get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;",
    ):
        body = method_body(sem_properties, signature)
        require(body, 'const-string/jumbo v0, "ril.serialnumber"', "serial property selector")
        require(body, "BuildSpoof;->getSerialNumber()Ljava/lang/String;", "serial property hook")

    build_get_serial = method_body(build, ".method public static whitelist getSerial()Ljava/lang/String;")
    require(build_get_serial, "BuildSpoof;->getSerialNumber()Ljava/lang/String;", "Build.getSerial hook")
    require(build_get_serial, ":cond_device_identifier", "normal Build.getSerial fallback")

    print("Serial hook structure: OK")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except AssertionError as error:
        print(f"Serial hook structure: FAILED: {error}", file=sys.stderr)
        raise SystemExit(1)
