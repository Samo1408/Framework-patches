#!/usr/bin/env python3
"""Structural checks for serial and build-property override wiring."""

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
    build_version = ROOT / "patches/android/os/Build$VERSION.smali"

    serial_helper = method_body(build_spoof, ".method public static declared-synchronized getSerialNumber()")
    require(serial_helper, 'const-string v0, "serialNumber"', "preferred serialNumber key")
    require(serial_helper, 'const-string v0, "serialnumber"', "legacy serialnumber key")
    require(serial_helper, 'const-string v0, "ril.serialnumber"', "ril.serialnumber key")
    non_empty = method_body(build_spoof, ".method private static nonEmpty(Ljava/lang/String;)Z")
    require(non_empty, "String;->trim()Ljava/lang/String;", "empty-value trimming")
    require(serial_helper, "BuildSpoof;->get(Ljava/lang/String;)Ljava/lang/String;", "serial overlay reader")

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

    helper = method_body(build_spoof, ".method public static getOrSystemProperty(Ljava/lang/String;)Ljava/lang/String;")
    require(helper, "BuildSpoof;->get(Ljava/lang/String;)Ljava/lang/String;", "spoof-first property helper")
    require(helper, "SystemProperties;->get(Ljava/lang/String;)Ljava/lang/String;", "normal property fallback")
    int_helper = method_body(build_spoof, ".method public static getInt(Ljava/lang/String;I)I")
    require(int_helper, "Integer;->parseInt(Ljava/lang/String;)I", "numeric override parser")
    require(int_helper, "SystemProperties;->getInt(Ljava/lang/String;I)I", "normal numeric fallback")
    alias_helper = method_body(build_spoof, ".method private static getAlias(Ljava/lang/String;)Ljava/lang/String;")
    require(alias_helper, 'const-string v0, "baseband"', "baseband alias selector")
    require(alias_helper, 'const-string v0, "ro.baseband"', "canonical baseband alias")

    list_helper = method_body(build, ".method private static greylist-max-o getStringList(Ljava/lang/String;Ljava/lang/String;)[Ljava/lang/String;")
    require(list_helper, "BuildSpoof;->getOrSystemProperty(Ljava/lang/String;)Ljava/lang/String;", "list property hook")
    long_helper = method_body(build, ".method private static greylist getLong(Ljava/lang/String;)J")
    require(long_helper, "BuildSpoof;->getOrSystemProperty(Ljava/lang/String;)Ljava/lang/String;", "long property hook")

    consistency = method_body(build, ".method public static greylist-max-o isBuildConsistent()Z")
    for key in ("ro.system.build.fingerprint", "ro.vendor.build.fingerprint", "ro.bootimage.build.fingerprint"):
        require(consistency, key, f"{key} consistency check")
    if consistency.count("BuildSpoof;->getOrSystemProperty(Ljava/lang/String;)Ljava/lang/String;") < 3:
        raise AssertionError("Partition fingerprints do not all use the spoof-aware reader")

    version_init = method_body(build_version, ".method static constructor blacklist <clinit>()V")
    for key in ("ro.build.version.base_os", "ro.build.version.security_patch", "ro.build.version.security_index"):
        require(version_init, key, f"{key} version field")
    require(version_init, "BuildSpoof;->getOrSystemProperty(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;", "version string hook")
    require(version_init, "BuildSpoof;->getInt(Ljava/lang/String;I)I", "version numeric hook")

    print("Serial and build-property hook structure: OK")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except AssertionError as error:
        print(f"Serial hook structure: FAILED: {error}", file=sys.stderr)
        raise SystemExit(1)
