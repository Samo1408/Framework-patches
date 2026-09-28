# Android 14 sim-cached patch

This patch package contains only the A14-compatible changes derived from the supplied
Android 13 `sim-cached_A13.zip` and the supplied A14 original smali set.

The build is intentionally performed per existing `classes*.dex` file. The original
framework.jar is disassembled one DEX at a time, the four modified classes are replaced,
and `android/location/Spoof.smali` is added to `classes6.dex`. Each DEX is assembled back
independently and the original JAR is repacked without changing the DEX count/order.

This avoids the failure mode of the earlier build where references to `Spoof` existed but
the `Spoof` class was absent from the final DEX.

Requirements:
- Android 14 framework.jar from the same firmware/build.
- Java 17.
- baksmali/smali 3.0.9 fat jars (downloaded by the workflow).

Do not use the previously generated `framework_A14_sim-cached_fixed.jar`.
\n## v3 diagnostics\n\nThe build script assembles each DEX separately with a bounded Java heap and logs each assembly. On failure, `build-debug/` is preserved and uploaded as a diagnostic artifact.\n

## DEX format and compression
The build keeps the compressed ZIP/JAR output. After assembly, generated DEX files are normalized to DEX 039 and their SHA-1 signature and Adler-32 checksum are recalculated. The workflow verifies that all six DEX files are version 039 before publishing the artifact.


## BuildSpoof runtime overrides

This version patches `android/os/Build.smali` and `Build$VERSION.smali` directly from `tools/build_framework.sh`, and adds `android/os/BuildSpoof.smali` to `classes3.dex`. At runtime it reads `the primary /data/system/devicespoof/build.prop path (legacy fallback: /data/build.prop)` and reloads the parsed values when that file's
modification time changes. Exact Android property names and short aliases are accepted. For
example `model=SM-A145F` overrides `ro.product.model`, and `fingerprint=...` overrides
`ro.build.fingerprint`. If `the primary /data/system/devicespoof/build.prop path (legacy fallback: /data/build.prop)` is absent or a key is absent, the original
`SystemProperties` value is used.

The archive includes `data/build.prop` as a template; installing the framework JAR alone does not create `the primary /data/system/devicespoof/build.prop path (legacy fallback: /data/build.prop)`. A later flashable ZIP can install that template as `the primary /data/system/devicespoof/build.prop path (legacy fallback: /data/build.prop)`.

## Serial number and build-property overrides
Set `serialNumber=...` in `the primary /data/system/devicespoof/build.prop path (legacy fallback: /data/build.prop)` to enable the serial-number override. The legacy
`serialnumber` spelling remains supported. `SemSystemProperties.getDeviceSerialNumber()`,
`Build.getSerial()`, and reads of `ril.serialnumber` through `SemSystemProperties` return this
non-empty override. When neither key is set (or it is empty), each path keeps its original
platform behavior.

`BuildSpoof` now also provides a spoof-first, system-property fallback for `Build.VERSION`
strings and numbers, ABI/codename lists, and the three partition fingerprints examined by
`Build.isBuildConsistent()`. This allows values written by the companion app to reach their
corresponding framework paths without changing unrelated properties. A blank or absent key
continues to read the original platform property.

The companion app writes the canonical `ro.baseband` key. `BuildSpoof` maps the existing
`Build.getRadioVersion()` lookup for `baseband` to this key before using the original modem
property, so the override remains optional and absent values preserve the platform behavior.
`Build.RADIO` now uses the same overlay before its original telephony fallback. The Android 14
`SOC_MANUFACTURER` and `SOC_MODEL` initializers previously bypassed `Build.getString()` through
`SocProperties`; they now use `BuildSpoof.getOrSystemProperty()` with their original `unknown`
fallback, so `ro.soc.manufacturer` and `ro.soc.model` can reach their corresponding Build fields.

## Applying and verifying a preset

Saving a preset changes only `the primary /data/system/devicespoof/build.prop path (legacy fallback: /data/build.prop)`; it intentionally does **not** edit the
installed `framework.jar`. The installed, patched JAR must be rebuilt from this project for
the exact device firmware and installed through the device's normal framework replacement
procedure. `tools/verify_framework_compat.py` rejects a JAR that lacks the required six-DEX,
Android 14 layout before the builder changes it.

The builder also runs `tools/verify_framework_compat.py --patched-output` on its output. It
checks the DEX layout plus the `BuildSpoof`, `the primary /data/system/devicespoof/build.prop path (legacy fallback: /data/build.prop)`, SoC, and Country-operator
markers. This is a structural check only: it proves neither that this exact JAR is installed on
the phone nor that a process has reloaded it.

`Build.getSerial()` and `Build.getRadioVersion()` can observe a refreshed overlay through
their patched path. `Build` and `Build.VERSION` fields are static values captured when their
process initializes, so reboot the device after changing identity/fingerprint fields. Then use
the companion app's **Read & verify hooks** report to compare runtime `Build` values and the
serial path to the app's saved applied-values snapshot. The app does not compare an unapplied
preset to runtime values, classifies a `Build.getSerial()` `SecurityException` as
permission-restricted rather than a hook failure, and does not claim a partition-fingerprint
API check or prove behavior on a different firmware.

## Country and operator overlay

`android/location/Spoof` now reads `ro.product.locale` through `BuildSpoof`, so the companion
app's `the primary /data/system/devicespoof/build.prop path (legacy fallback: /data/build.prop)` overlay can select the existing country dataset without editing the
system property service. It keeps the existing country cache, automatic location rotation, and
power-saving TTLs unchanged. `devicespoof.operator.numeric` and
`devicespoof.operator.name` are optional: when both are absent the original three-operator
rotation remains active; when present, `Spoof.getOpNumeric()` and `Spoof.getOpName()` return
the supplied pair before consulting that cache. These values feed the already patched
`TelephonyManager` and `SubscriptionInfo` paths.

The companion app's `CountryCatalog.java` is generated with
`tools/generate_country_catalog.py` directly from this `Spoof.smali`; run it after changing
country coordinates or operators so the UI exposes no values outside the hook dataset.
