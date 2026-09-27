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
