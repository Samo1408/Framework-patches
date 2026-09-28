from pathlib import Path
root=Path('/mnt/data/work/full')
bs=root/'patches/android/os/BuildSpoof.smali'
bs.write_text(r'''# classes3.dex
.class public final Landroid/os/BuildSpoof;
.super Ljava/lang/Object;
.source "BuildSpoof.java"

.field private static final FILE:Ljava/lang/String; = "/data/build.prop"
.field private static volatile PROPS:Ljava/util/Properties;
.field private static volatile sLoaded:Z
.field private static volatile sLastModified:J
.field private static volatile sLastLength:J

.method static constructor <clinit>()V
    .registers 3
    new-instance v0, Ljava/util/Properties;
    invoke-direct {v0}, Ljava/util/Properties;-><init>()V
    sput-object v0, Landroid/os/BuildSpoof;->PROPS:Ljava/util/Properties;
    const/4 v0, 0x0
    sput-boolean v0, Landroid/os/BuildSpoof;->sLoaded:Z
    const-wide/16 v1, -0x1
    sput-wide v1, Landroid/os/BuildSpoof;->sLastModified:J
    sput-wide v1, Landroid/os/BuildSpoof;->sLastLength:J
    return-void
.end method

.method private constructor <init>()V
    .registers 1
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method

.method private static declared-synchronized load()V
    .registers 10
    new-instance v0, Ljava/io/File;
    const-string v1, "/data/build.prop"
    invoke-direct {v0, v1}, Ljava/io/File;-><init>(Ljava/lang/String;)V
    invoke-virtual {v0}, Ljava/io/File;->exists()Z
    move-result v1
    if-eqz v1, :cond_fail

    invoke-virtual {v0}, Ljava/io/File;->lastModified()J
    move-result-wide v2
    invoke-virtual {v0}, Ljava/io/File;->length()J
    move-result-wide v4

    sget-boolean v1, Landroid/os/BuildSpoof;->sLoaded:Z
    if-eqz v1, :cond_read
    sget-wide v6, Landroid/os/BuildSpoof;->sLastModified:J
    cmp-long v1, v2, v6
    if-nez v1, :cond_read
    sget-wide v6, Landroid/os/BuildSpoof;->sLastLength:J
    cmp-long v1, v4, v6
    if-nez v1, :cond_read
    return-void

    :cond_read
    :try_start_2b
    new-instance v1, Ljava/io/FileInputStream;
    const-string v6, "/data/build.prop"
    invoke-direct {v1, v6}, Ljava/io/FileInputStream;-><init>(Ljava/lang/String;)V
    new-instance v6, Ljava/util/Properties;
    invoke-direct {v6}, Ljava/util/Properties;-><init>()V
    invoke-virtual {v6, v1}, Ljava/util/Properties;->load(Ljava/io/InputStream;)V
    invoke-virtual {v1}, Ljava/io/InputStream;->close()V

    sput-object v6, Landroid/os/BuildSpoof;->PROPS:Ljava/util/Properties;
    sput-wide v2, Landroid/os/BuildSpoof;->sLastModified:J
    sput-wide v4, Landroid/os/BuildSpoof;->sLastLength:J
    const/4 v1, 0x1
    sput-boolean v1, Landroid/os/BuildSpoof;->sLoaded:Z
    return-void
    :try_end_45
    .catch Ljava/lang/Throwable; {:try_start_2b .. :try_end_45} :catch_46

    :catch_46
    # Keep the last known-good property snapshot. Do not mark a failed read as loaded.
    return-void

    :cond_fail
    # File is absent. Keep any previous valid snapshot and allow a later retry.
    return-void
.end method

.method private static getAlias(Ljava/lang/String;)Ljava/lang/String;
    .registers 2
    const-string v0, "ro.product.manufacturer"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :a1
    const-string v0, "manufacturer"
    return-object v0
:a1
    const-string v0, "ro.product.brand"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :a2
    const-string v0, "brand"
    return-object v0
:a2
    const-string v0, "ro.product.model"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :a3
    const-string v0, "model"
    return-object v0
:a3
    const-string v0, "ro.product.device"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :a4
    const-string v0, "device"
    return-object v0
:a4
    const-string v0, "ro.product.name"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :a5
    const-string v0, "product"
    return-object v0
:a5
    const-string v0, "ro.product.locale"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :a6
    const-string v0, "locale"
    return-object v0
:a6
    const-string v0, "ro.product.board"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :a7
    const-string v0, "board"
    return-object v0
:a7
    const-string v0, "ro.build.fingerprint"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :a8
    const-string v0, "fingerprint"
    return-object v0
:a8
    const-string v0, "ro.build.tags"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :a9
    const-string v0, "tags"
    return-object v0
:a9
    const-string v0, "ro.build.type"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :a10
    const-string v0, "type"
    return-object v0
:a10
    const-string v0, "ro.build.id"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :a11
    const-string v0, "id"
    return-object v0
:a11
    const-string v0, "ro.build.display.id"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :a12
    const-string v0, "display_id"
    return-object v0
:a12
    const-string v0, "ro.build.version.release"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :a13
    const-string v0, "release"
    return-object v0
:a13
    const-string v0, "ro.build.version.codename"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :a14
    const-string v0, "codename"
    return-object v0
:a14
    const-string v0, "ro.build.version.sdk"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :a15
    const-string v0, "sdk"
    return-object v0
:a15
    const-string v0, "ro.product.first_api_level"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :a16
    const-string v0, "first_api_level"
    return-object v0
:a16
    const-string v0, "ro.product.cpu.abilist"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :a17
    const-string v0, "cpu_abilist"
    return-object v0
:a17
    const-string v0, "ro.product.cpu.abilist32"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :a18
    const-string v0, "cpu_abilist32"
    return-object v0
:a18
    const-string v0, "ro.product.cpu.abilist64"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :a19
    const-string v0, "cpu_abilist64"
    return-object v0
:a19
    const-string v0, "ro.boot.container"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :a20
    const-string v0, "boot_container"
    return-object v0
:a20
    const-string v0, "ro.boot.hardware.sku"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :a21
    const-string v0, "boot_hardware_sku"
    return-object v0
:a21
    const-string v0, "ro.boot.product.hardware.sku"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :a22
    const-string v0, "boot_product_hardware_sku"
    return-object v0
:a22
    const-string v0, "ro.boot.qemu"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :a23
    const-string v0, "boot_qemu"
    return-object v0
:a23
    const-string v0, "ro.treble.enabled"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :a24
    const-string v0, "treble_enabled"
    return-object v0
:a24
    const-string v0, "ro.debuggable"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :a25
    const-string v0, "debuggable"
    return-object v0
:a25
    const-string v0, "ro.hw_timeout_multiplier"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :a26
    const-string v0, "hw_timeout_multiplier"
    return-object v0
:a26
    const-string v0, "ro.build.version.security_patch"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :a27
    const-string v0, "security_patch"
    return-object v0
:a27
    const-string v0, "ro.build.version.security_index"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :a28
    const-string v0, "security_index"
    return-object v0
:a28
    const-string v0, "ro.build.version.preview_sdk"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :a29
    const-string v0, "preview_sdk"
    return-object v0
:a29
    const-string v0, "ro.build.version.sem"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :a30
    const-string v0, "sem"
    return-object v0
:a30
    const-string v0, "ro.build.version.sep"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :a31
    const-string v0, "sep"
    return-object v0
:a31
    const-string v0, "ro.build.version.min_supported_target_sdk"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :a32
    const-string v0, "min_supported_target_sdk"
    return-object v0
:a32
    const-string v0, "ro.build.version.preview_sdk_fingerprint"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :a33
    const-string v0, "preview_sdk_fingerprint"
    return-object v0
:a33
    const-string v0, "ro.boot.baseband"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :a34
    const-string v0, "baseband"
    return-object v0
:a34
    const-string v0, "serialNumber"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :a35
    const-string v0, "serialNumber"
    return-object v0
:a35
    const-string v0, "serialnumber"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :a36
    const-string v0, "serialnumber"
    return-object v0
:a36
    return-object p0
.end method

.method public static declared-synchronized get(Ljava/lang/String;)Ljava/lang/String;
    .registers 7
    if-eqz p0, :none
    invoke-static {}, Landroid/os/BuildSpoof;->load()V
    sget-object v0, Landroid/os/BuildSpoof;->PROPS:Ljava/util/Properties;

    invoke-virtual {v0, p0}, Ljava/util/Properties;->containsKey(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :alias
    invoke-virtual {v0, p0}, Ljava/util/Properties;->getProperty(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1
    if-eqz v1, :alias
    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z
    move-result v2
    if-nez v2, :alias
    return-object v1

:alias
    invoke-static {p0}, Landroid/os/BuildSpoof;->getAlias(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1
    invoke-virtual {v0, v1}, Ljava/util/Properties;->containsKey(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :prefix
    invoke-virtual {v0, v1}, Ljava/util/Properties;->getProperty(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1
    if-eqz v1, :prefix
    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z
    move-result v2
    if-nez v2, :prefix
    return-object v1

:prefix
    const-string v2, "ro.product."
    invoke-virtual {p0, v2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v2
    if-eqz v2, :buildprefix
    const/16 v2, 0xb
    invoke-virtual {p0, v2}, Ljava/lang/String;->substring(I)Ljava/lang/String;
    move-result-object v2
    invoke-virtual {v0, v2}, Ljava/util/Properties;->containsKey(Ljava/lang/Object;)Z
    move-result v3
    if-eqz v3, :buildprefix
    invoke-virtual {v0, v2}, Ljava/util/Properties;->getProperty(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1
    if-eqz v1, :buildprefix
    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z
    move-result v3
    if-nez v3, :buildprefix
    return-object v1

:buildprefix
    const-string v2, "ro.build."
    invoke-virtual {p0, v2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v2
    if-eqz v2, :none
    const/16 v2, 0x9
    invoke-virtual {p0, v2}, Ljava/lang/String;->substring(I)Ljava/lang/String;
    move-result-object v2
    invoke-virtual {v0, v2}, Ljava/util/Properties;->containsKey(Ljava/lang/Object;)Z
    move-result v3
    if-eqz v3, :none
    invoke-virtual {v0, v2}, Ljava/util/Properties;->getProperty(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1
    if-eqz v1, :none
    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z
    move-result v3
    if-eqz v3, :ret
    goto :none
:ret
    return-object v1
:none
    const/4 v0, 0x0
    return-object v0
.end method

.method public static getInt(Ljava/lang/String;I)I
    .registers 4
    invoke-static {p0}, Landroid/os/BuildSpoof;->get(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    if-eqz v0, :system
    :try_start_7
    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I
    move-result v0
    return v0
    :try_end_b
    .catch Ljava/lang/NumberFormatException; {:try_start_7 .. :try_end_b} :system
:system
    invoke-static {p0, p1}, Landroid/os/SystemProperties;->getInt(Ljava/lang/String;I)I
    move-result v0
    return v0
.end method

.method public static getLong(Ljava/lang/String;J)J
    .registers 5
    invoke-static {p0}, Landroid/os/BuildSpoof;->get(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    if-eqz v0, :system
    :try_start_7
    invoke-static {v0}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J
    move-result-wide v0
    return-wide v0
    :try_end_b
    .catch Ljava/lang/NumberFormatException; {:try_start_7 .. :try_end_b} :system
:system
    return-wide p1
.end method

.method public static getBoolean(Ljava/lang/String;Z)Z
    .registers 3
    invoke-static {p0}, Landroid/os/BuildSpoof;->get(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    if-eqz v0, :system
    const-string v1, "1"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-nez v1, :yes
    const-string v1, "true"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z
    move-result v1
    if-eqz v1, :no
:yes
    const/4 v0, 0x1
    return v0
:no
    const/4 v0, 0x0
    return v0
:system
    invoke-static {p0, p1}, Landroid/os/SystemProperties;->getBoolean(Ljava/lang/String;Z)Z
    move-result v0
    return v0
.end method

.method public static getSerialNumber()Ljava/lang/String;
    .registers 2
    const-string v0, "serialNumber"
    invoke-static {v0}, Landroid/os/BuildSpoof;->get(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1
    if-eqz v1, :legacy
    return-object v1
:legacy
    const-string v0, "serialnumber"
    invoke-static {v0}, Landroid/os/BuildSpoof;->get(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1
    if-eqz v1, :none
    return-object v1
:none
    const/4 v0, 0x0
    return-object v0
.end method
''')

b=root/'patches/android/os/Build.smali'
s=b.read_text()
# helper methods in static init
s=s.replace('invoke-static {v2, v3}, Landroid/os/SystemProperties;->getInt(Ljava/lang/String;I)I\n    move-result v2\n    sput v2, Landroid/os/Build;->HW_TIMEOUT_MULTIPLIER:I',
'''invoke-static {v2, v3}, Landroid/os/BuildSpoof;->getInt(Ljava/lang/String;I)I
    move-result v2
    sput v2, Landroid/os/Build;->HW_TIMEOUT_MULTIPLIER:I''')
s=s.replace('invoke-static {v2, v1}, Landroid/os/SystemProperties;->getBoolean(Ljava/lang/String;Z)Z\n    move-result v2\n    sput-boolean v2, Landroid/os/Build;->IS_TREBLE_ENABLED:Z',
'''invoke-static {v2, v1}, Landroid/os/BuildSpoof;->getBoolean(Ljava/lang/String;Z)Z
    move-result v2
    sput-boolean v2, Landroid/os/Build;->IS_TREBLE_ENABLED:Z''')
s=s.replace('invoke-static {v2, v1}, Landroid/os/SystemProperties;->getInt(Ljava/lang/String;I)I\n\n    if-ne v2, v3',
'''invoke-static {v2, v1}, Landroid/os/BuildSpoof;->getInt(Ljava/lang/String;I)I

    if-ne v2, v3''')
s=s.replace('invoke-static {v0, v1}, Landroid/os/SystemProperties;->getBoolean(Ljava/lang/String;Z)Z\n    move-result v0\n    sput-boolean v0, Landroid/os/Build;->IS_ARC:Z',
'''invoke-static {v0, v1}, Landroid/os/BuildSpoof;->getBoolean(Ljava/lang/String;Z)Z
    move-result v0
    sput-boolean v0, Landroid/os/Build;->IS_ARC:Z''')
# list helper
old='''    invoke-static {p0}, Landroid/os/SystemProperties;->get(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0
    .local v0, "value":Ljava/lang/String;'''
new='''    invoke-static {p0}, Landroid/os/BuildSpoof;->get(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    if-eqz v0, :system_list
    goto :have_value
:system_list
    invoke-static {p0}, Landroid/os/SystemProperties;->get(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
:have_value
    .local v0, "value":Ljava/lang/String;'''
s=s.replace(old,new,1)
# getLong helper: spoof then fallback sentinel
old='''    :try_start_0
    invoke-static {p0}, Landroid/os/SystemProperties;->get(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0
    invoke-static {v0}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J
    move-result-wide v0
    :try_end_8
    .catch Ljava/lang/NumberFormatException; {:try_start_0 .. :try_end_8} :catch_9

    return-wide v0'''
new='''    :try_start_0
    invoke-static {p0}, Landroid/os/BuildSpoof;->getLong(Ljava/lang/String;J)J
    move-result-wide v0
    return-wide v0
    :try_end_8
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_8} :catch_9'''
s=s.replace(old,new,1)
# serial: insert spoof before service
needle='''    .line 258
    nop

    .line 259'''
rep='''    .line 258
    invoke-static {}, Landroid/os/BuildSpoof;->getSerialNumber()Ljava/lang/String;
    move-result-object v0
    if-eqz v0, :service
    return-object v0

:service
    nop

    .line 259'''
s=s.replace(needle,rep,1)
# fingerprint partition reads
s=s.replace('invoke-static {v4}, Landroid/os/SystemProperties;->get(Ljava/lang/String;)Ljava/lang/String;\n    move-result-object v11',
'''invoke-static {v4}, Landroid/os/BuildSpoof;->get(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v11
    if-eqz v11, :part_system
    goto :part_have
:part_system
    invoke-static {v4}, Landroid/os/SystemProperties;->get(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v11
:part_have''',1)
# ensure fingerprint read should use spoof but avoid setting actual property
s=s.replace('''    const-string/jumbo v0, "ro.build.fingerprint"
    invoke-static {v0}, Landroid/os/SystemProperties;->get(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1''','''    const-string/jumbo v0, "ro.build.fingerprint"
    invoke-static {v0}, Landroid/os/BuildSpoof;->get(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1
    if-eqz v1, :ensure_system
    goto :ensure_check
:ensure_system
    invoke-static {v0}, Landroid/os/SystemProperties;->get(Ljava/lang/String;)Ljava/lang/String;
:ensure_check''',1)
b.write_text(s)

v=root/'patches/android/os/Build$VERSION.smali'
s=v.read_text()
repls={
'invoke-static {v0, v1}, Landroid/os/SystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;':'invoke-static {v0}, Landroid/os/BuildSpoof;->get(Ljava/lang/String;)Ljava/lang/String;',
'invoke-static {v0, v1}, Landroid/os/SystemProperties;->getInt(Ljava/lang/String;I)I':'invoke-static {v0, v1}, Landroid/os/BuildSpoof;->getInt(Ljava/lang/String;I)I',
'invoke-static {v2, v1}, Landroid/os/SystemProperties;->getInt(Ljava/lang/String;I)I':'invoke-static {v2, v1}, Landroid/os/BuildSpoof;->getInt(Ljava/lang/String;I)I',
'invoke-static {v2, v3}, Landroid/os/SystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;':'invoke-static {v2}, Landroid/os/BuildSpoof;->get(Ljava/lang/String;)Ljava/lang/String;',
}
for a,c in repls.items(): s=s.replace(a,c)
# For string defaults that got removed, add fallback blocks is cumbersome; get() null would be stored. Change helper getString in Build? VERSION fields can be null. Better wrap specific three string props with Build.getString.
# Replace direct BuildSpoof string calls with Build.getString where defaults are expected.
s=s.replace('invoke-static {v0}, Landroid/os/BuildSpoof;->get(Ljava/lang/String;)Ljava/lang/String;','invoke-static {v0}, Landroid/os/Build;->-$$Nest$smgetString(Ljava/lang/String;)Ljava/lang/String;',3)
s=s.replace('invoke-static {v2}, Landroid/os/BuildSpoof;->get(Ljava/lang/String;)Ljava/lang/String;','invoke-static {v2}, Landroid/os/Build;->-$$Nest$smgetString(Ljava/lang/String;)Ljava/lang/String;',1)
v.write_text(s)
