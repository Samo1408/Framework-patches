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

This version patches `android/os/Build.smali` and `Build$VERSION.smali` directly from `tools/build_framework.sh`, and adds `android/os/BuildSpoof.smali` to `classes3.dex`. At runtime it reads `/data/build.prop` once and caches the parsed values. Exact Android property names and short aliases are accepted. For example `model=SM-A145F` overrides `ro.product.model`, and `fingerprint=...` overrides `ro.build.fingerprint`. If `/data/build.prop` is absent or a key is absent, the original `SystemProperties` value is used.

The archive includes `data/build.prop` as a template; installing the framework JAR alone does not create `/data/build.prop`. A later flashable ZIP can install that template as `/data/build.prop`.

## Serial number spoof
`SemSystemProperties.getDeviceSerialNumber()` first reads the `serialnumber` key from `/data/build.prop` through `BuildSpoof`; when absent/empty it falls back to the original `ril.serialnumber` property.

## Samsung Sales Code

`android/os/SemSystemProperties.smali` now routes `getSalesCode()` through `BuildSpoof`
only when the selected manufacturer is Samsung. For non-Samsung selections, the hook does
not apply the `/data/build.prop` sales-code override and the original system property is used.
The companion Device Spoofing UI exposes `ro.csc.sales_code` only for Samsung selections and
allows manual values such as `XAA`, `BTU`, `DBT`, `INS`, and `XXV`.
