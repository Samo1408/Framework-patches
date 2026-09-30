# Android 14 sim-cached patch

This patch package contains only the A14-compatible changes derived from the supplied
Android 13 `sim-cached_A13.zip` and the supplied A14 original smali set.

The build is performed per existing `classes*.dex` file. The original framework.jar is
disassembled one DEX at a time, target classes are located by descriptor, and only the
project's hook methods are replaced. The remaining Samsung/vendor-specific methods and
fields are preserved. Each DEX is assembled back independently and the original JAR is
repacked without changing the DEX count/order.

This avoids the failure mode where references to `Spoof` exist but the helper is placed
in a hard-coded DEX that does not exist in another Samsung build.

Requirements:
- Samsung Android 14 framework.jar with the standard framework target classes.
- Java 17.
- baksmali/smali 3.0.9 fat jars (downloaded by the workflow).

Do not use the previously generated `framework_A14_sim-cached_fixed.jar`.
\n## v3 diagnostics\n\nThe build script assembles each DEX separately with a bounded Java heap and logs each assembly. On failure, `build-debug/` is preserved and uploaded as a diagnostic artifact.\n

## DEX format and compression
The build keeps the compressed ZIP/JAR output. After assembly, generated DEX files are normalized to DEX 039 and their SHA-1 signature and Adler-32 checksum are recalculated. The workflow verifies the output DEX structure and preserves the input DEX count/order before publishing the artifact.


## BuildSpoof runtime overrides

Universal mode patches only the Build methods that call `BuildSpoof` and places `android/os/BuildSpoof.smali` beside the DEX containing `android/os/Build`. At runtime the helper reads `/system/spoof.prop`, caches the parsed values, and refreshes when the file metadata changes or the 20-second refresh window expires. Exact Android property names and short aliases are accepted. For example `model=SM-A145F` overrides `ro.product.model`, and `fingerprint=...` overrides `ro.build.fingerprint`. If `/data/build.prop` is absent or a key is absent, the original `SystemProperties` value is used.

The archive includes `data/build.prop` as the project's property template. The current `BuildSpoof` implementation reads `/system/spoof.prop`; the template is therefore a separate packaging asset unless another installer copies it to the runtime path.

## Serial number spoof
`SemSystemProperties.getDeviceSerialNumber()` first reads the `serialnumber` key from `/data/build.prop` through `BuildSpoof`; when absent/empty it falls back to the original `ril.serialnumber` property.


## Universal Samsung Android 14 mode

The builder is now framework-variant aware. Run:

```bash
./tools/build_framework.sh framework.jar framework_A14_sim-cached_patched.jar
```

It accepts any Samsung Android 14 `framework.jar` whose normal framework
classes are present, regardless of which `classesN.dex` contains them. The
builder disassembles all DEX files, locates classes by descriptor, and patches
only the methods used by the spoof hooks. It does not copy complete
`Build`, `Location`, `TelephonyManager`, or `SubscriptionInfo` classes from the
reference firmware.

The original DEX count and names are preserved. `BuildSpoof` and `Spoof` are
placed relative to their primary target classes rather than hard-coded to
`classes3.dex` and `classes6.dex`. A JSON patch report is written to the build
work directory as `logs/universal-patch.json`.

The old complete replacement of `Build$VERSION.smali` is deliberately not
used in universal mode because that file contained no project hook; keeping
the target firmware's own implementation avoids importing build-specific
Android/Samsung constants.
