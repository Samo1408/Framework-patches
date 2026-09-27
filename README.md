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
