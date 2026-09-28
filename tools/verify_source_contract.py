#!/usr/bin/env python3
"""Static checks for preset import, UI coverage, and framework hook wiring."""

from pathlib import Path
from zipfile import ZipFile
import json
import subprocess
import sys


ROOT = Path(__file__).resolve().parents[1]
APP = ROOT / "application/appv7"
HOOK = ROOT / "hook-project/sim_cached_a14_patch"
SAMPLES = (
    Path("/tmp/code/static-assets/presets.zip"),
    Path("/tmp/code/static-assets/presets(1).zip"),
)


def require(text: str, value: str, description: str) -> None:
    if value not in text:
        raise AssertionError(f"Missing {description}: {value}")


def method_body(path: Path, signature: str) -> str:
    text = path.read_text(encoding="utf-8")
    start = text.find(signature)
    if start < 0:
        raise AssertionError(f"Missing method {signature} in {path}")
    end = text.find(".end method", start)
    if end < 0:
        raise AssertionError(f"Unterminated method {signature} in {path}")
    return text[start:end]


def is_android_fingerprint(value: str) -> bool:
    parts = value.split(":")
    if len(parts) != 3:
        return False
    identity, build, variant = (part.split("/") for part in parts)
    groups = (identity, build, variant)
    expected_lengths = (3, 3, 2)
    return all(len(group) == length and all(
        atom and not any(char.isspace() for char in atom) and "/" not in atom and ":" not in atom
        for atom in group
    ) for group, length in zip(groups, expected_lengths))


def validate_sample(sample: Path) -> tuple[int, int]:
    valid = 0
    metadata_only = 0
    with ZipFile(sample) as archive:
        assert archive.testzip() is None, "preset ZIP has corrupt member"
        for info in archive.infolist():
            if info.is_dir() or not info.filename.lower().endswith(".json"):
                continue
            root = json.loads(archive.read(info))
            profile = root.get("profile")
            if not isinstance(profile, dict):
                assert root.get("schema") or isinstance(root.get("device"), dict), (
                    f"{info.filename}: unsupported non-profile JSON in sample"
                )
                metadata_only += 1
                continue
            for key in ("manufacturer", "brand", "model", "productName", "deviceCode", "buildFingerprint"):
                assert profile.get(key), f"{info.filename}: missing {key}"
            fp = profile["buildFingerprint"]
            assert is_android_fingerprint(fp), f"{info.filename}: invalid fingerprint"
            valid += 1
    assert valid == 85, f"expected 85 importable sample profiles, got {valid}"
    assert metadata_only == 10, f"expected 10 metadata-only JSON files, got {metadata_only}"
    return valid, metadata_only


def main() -> int:
    activity = (APP / "app/src/main/java/com/example/devicespoof/MainActivity.java").read_text(encoding="utf-8")
    presets = (APP / "app/src/main/java/com/example/devicespoof/Presets.java").read_text(encoding="utf-8")
    manifest = (APP / "app/src/main/AndroidManifest.xml").read_text(encoding="utf-8")
    layout = (APP / "app/src/main/res/layout/activity_main.xml").read_text(encoding="utf-8")
    build = HOOK / "patches/android/os/Build.smali"
    spoof = HOOK / "patches/android/os/BuildSpoof.smali"
    runtime_probe = APP / "app/src/main/java/com/example/devicespoof/RuntimeHookProbe.java"
    framework_guard = HOOK / "tools/verify_framework_compat.py"
    builder = HOOK / "tools/build_framework.sh"

    for key in ("serialNumber", "ro.bootloader", "ro.baseband", "ro.build.version.incremental",
                "ro.system.build.fingerprint", "ro.vendor.build.fingerprint", "ro.bootimage.build.fingerprint"):
        require(activity, f'f("{key}"', "application field")
    for label in ("Add Presets", "Random SN", "En/Ar", "ACTION_OPEN_DOCUMENT", "takePersistableUriPermission"):
        require(activity, label, "requested UI/import control")
    require(activity, "SecureRandom", "serial generator")
    require(activity, "previous set was completely replaced", "replacement result")
    require(activity, "previous set was kept", "failed-import preservation result")
    require(activity, "matchesBuild", "partition fingerprint consistency check")
    require(activity, "Derived/unverified", "derived partition disclosure")
    require(activity, "getSharedPreferences", "persisted UI language")
    require(layout, "btnAddPresets", "preset import button")
    require(layout, "btnLanguage", "language button")
    require(manifest, "supportsRtl", "RTL support")
    if "Samsung.add(" in presets or "DATA.put(" in presets:
        raise AssertionError("A built-in device profile database remains")
    for text in ("ZipInputStream", "importFromUri", "CACHE_NAME", "parts.incremental", "systemBuildFingerprint",
                 "parseJsonProfile", "looksLikeProfile", "metadata-only JSON", "entry.getName()",
                 "No importable device profiles", "estimateFingerprint", "estimated", "invalid",
                 "addIndependentBuildFields", "parts = estimated;", 'split(":", -1)', 'split("/", -1)'):
        require(presets, text, "preset importer")
    for text in ('split(":", -1)', 'split("/", -1)', "checkbox_button", "Apply: on", "تطبيق: مفعّل"):
        require(activity, text, "fingerprint/checkbox UI behavior")
    for drawable in ("checkbox_button.xml", "checkbox_checked.xml", "checkbox_unchecked.xml"):
        assert (APP / "app/src/main/res/drawable" / drawable).is_file(), f"missing explicit checkbox drawable: {drawable}"
    require(activity, "RuntimeHookProbe.verify", "runtime hook probe")
    require(activity, "framework.jar was not modified", "honest apply report")
    require(activity, "Read & verify hooks", "post-reboot verification control")
    require(activity, "cannot contain a newline", "property-file injection protection")
    assert runtime_probe.is_file(), "missing RuntimeHookProbe"
    probe = runtime_probe.read_text(encoding="utf-8")
    for text in ("Build.getSerial()", "Build.getRadioVersion()", "Build.FINGERPRINT",
                 "Build.VERSION.INCREMENTAL", "mismatched", "unavailable"):
        require(probe, text, "runtime probe path")

    alias = method_body(spoof, ".method private static getAlias(Ljava/lang/String;)Ljava/lang/String;")
    require(alias, '"baseband"', "baseband alias")
    require(alias, '"ro.baseband"', "canonical baseband alias")
    reload_body = method_body(spoof, ".method private static load()V")
    for text in ("sLastModified", "File;->lastModified()J", "Properties;->clear()V"):
        require(reload_body, text, "reloadable overlay")
    require(method_body(spoof, ".method static constructor <clinit>()V"), ".registers 2",
            "wide reload timestamp initialization")
    serial = method_body(spoof, ".method public static declared-synchronized getSerialNumber()")
    require(serial, '"serialNumber"', "serialNumber helper")
    get_radio = method_body(build, ".method public static whitelist getRadioVersion()Ljava/lang/String;")
    require(get_radio, 'const-string v0, "baseband"', "radio override path")
    assert framework_guard.is_file(), "missing framework compatibility guard"
    require(builder.read_text(encoding="utf-8"), "verify_framework_compat.py", "pre-patch framework guard")

    framework = Path("/tmp/code/static-assets/framework.jar")
    guard = subprocess.run(
        [sys.executable, str(framework_guard), str(framework)],
        text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=False,
    )
    assert guard.returncode == 0, "uploaded framework rejected: " + guard.stdout + guard.stderr
    assert "BuildSpoof is present" in guard.stdout, "uploaded framework lacks BuildSpoof"

    counts = [validate_sample(sample) for sample in SAMPLES]
    assert counts[0] == counts[1], "the supplied preset ZIPs import different profile counts"
    count, metadata_only = counts[0]
    print(f"Preset import and source contract: OK ({count} imported sample profiles; "
          f"{metadata_only} metadata-only JSON files reported and skipped in both ZIPs; "
          "uploaded framework is structurally compatible and contains BuildSpoof)")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (AssertionError, KeyError, ValueError, OSError) as error:
        print(f"Preset import and source contract: FAILED: {error}", file=sys.stderr)
        raise SystemExit(1)
