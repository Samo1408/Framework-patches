# Updated BuildSpoof / Device Spoofing source

## Framework changes
- Rebuilt `android/os/BuildSpoof.smali` as a reloadable property snapshot reader.
- Reads `/data/build.prop` and atomically swaps the property snapshot only after a successful parse.
- Missing/unreadable files do not permanently disable spoofing.
- Reloads when file mtime or size changes.
- Empty values fall back to the real system property.
- Added typed `getInt`, `getLong`, `getBoolean` helpers.
- Added locale and serial-number aliases.
- `Build.smali` routes spoofable integer/boolean/list/long/serial paths through `BuildSpoof`.
- `Build$VERSION.smali` routes SDK, first API, preview, SEM/SEP, security and related fields through the spoof layer.
- `Spoof.smali` remains the locale/SIM hook and reads through `BuildSpoof`.

## Device Spoofing app changes
- Added `locale`, `ro.product.locale`, `serialNumber`, and `serialnumber` fields.
- Removed literal template keys containing `%s` from the UI.
- Added concrete attestation fields.
- Fixed remote preset SDK conversion: Android release 14 -> API 34, 15 -> 35, 16 -> 36, etc.

## Important runtime behavior
`Build` and `Build$VERSION` expose many static-final values. The `/data/build.prop` file therefore needs to exist with the desired values before the relevant framework process initializes. The reloadable reader prevents a permanent early-read failure, but it cannot retroactively change an already initialized static-final field.

The project does not modify `/system/build.prop`; spoof values are read from `/data/build.prop`.
