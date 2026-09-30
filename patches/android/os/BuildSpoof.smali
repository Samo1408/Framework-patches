# classes3.dex
.class public final Landroid/os/BuildSpoof;
.super Ljava/lang/Object;
.source "BuildSpoof.java"

.field private static final FILE:Ljava/lang/String; = "/system/spoof.prop"
.field private static final PROPS:Ljava/util/Properties;
.field private static volatile sLoaded:Z
.field private static volatile sLastCheck:J
.field private static volatile sLastModified:J
.field private static volatile sLastLength:J

.method static constructor <clinit>()V
    .registers 1
    new-instance v0, Ljava/util/Properties;
    invoke-direct {v0}, Ljava/util/Properties;-><init>()V
    sput-object v0, Landroid/os/BuildSpoof;->PROPS:Ljava/util/Properties;
    const/4 v0, 0x0
    sput-boolean v0, Landroid/os/BuildSpoof;->sLoaded:Z
    return-void
.end method

.method private constructor <init>()V
    .registers 1
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method

# Reload the framework-visible spoof file when it changes. The retry interval
# is deliberately short so a file created after boot is not cached as "empty".
.method private static load()V
    .registers 10
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J
    move-result-wide v0

    sget-wide v2, Landroid/os/BuildSpoof;->sLastCheck:J
    sub-long v4, v0, v2
    const-wide/32 v6, 0x4e20
    cmp-long v2, v4, v6
    if-gez v2, :cond_check_file
    sget-boolean v2, Landroid/os/BuildSpoof;->sLoaded:Z
    if-eqz v2, :cond_check_file
    return-void

    :cond_check_file
    sput-wide v0, Landroid/os/BuildSpoof;->sLastCheck:J

    new-instance v2, Ljava/io/File;
    const-string v3, "/system/spoof.prop"
    invoke-direct {v2, v3}, Ljava/io/File;-><init>(Ljava/lang/String;)V
    invoke-virtual {v2}, Ljava/io/File;->exists()Z
    move-result v3
    if-nez v3, :cond_stat

    sget-object v3, Landroid/os/BuildSpoof;->PROPS:Ljava/util/Properties;
    invoke-virtual {v3}, Ljava/util/Properties;->clear()V
    const/4 v3, 0x0
    sput-boolean v3, Landroid/os/BuildSpoof;->sLoaded:Z
    const-wide/16 v4, 0x0
    sput-wide v4, Landroid/os/BuildSpoof;->sLastModified:J
    sput-wide v4, Landroid/os/BuildSpoof;->sLastLength:J
    return-void

    :cond_stat
    invoke-virtual {v2}, Ljava/io/File;->lastModified()J
    move-result-wide v4
    invoke-virtual {v2}, Ljava/io/File;->length()J
    move-result-wide v6

    sget-boolean v8, Landroid/os/BuildSpoof;->sLoaded:Z
    if-eqz v8, :cond_reload
    sget-wide v8, Landroid/os/BuildSpoof;->sLastModified:J
    cmp-long v8, v4, v8
    if-nez v8, :cond_reload
    sget-wide v8, Landroid/os/BuildSpoof;->sLastLength:J
    cmp-long v8, v6, v8
    if-eqz v8, :cond_done

    :cond_reload
    :try_start
    sget-object v8, Landroid/os/BuildSpoof;->PROPS:Ljava/util/Properties;
    invoke-virtual {v8}, Ljava/util/Properties;->clear()V
    new-instance v8, Ljava/io/FileInputStream;
    const-string v9, "/system/spoof.prop"
    invoke-direct {v8, v9}, Ljava/io/FileInputStream;-><init>(Ljava/lang/String;)V
    sget-object v9, Landroid/os/BuildSpoof;->PROPS:Ljava/util/Properties;
    invoke-virtual {v9, v8}, Ljava/util/Properties;->load(Ljava/io/InputStream;)V
    invoke-virtual {v8}, Ljava/io/InputStream;->close()V
    sput-wide v4, Landroid/os/BuildSpoof;->sLastModified:J
    sput-wide v6, Landroid/os/BuildSpoof;->sLastLength:J
    const/4 v8, 0x1
    sput-boolean v8, Landroid/os/BuildSpoof;->sLoaded:Z
    return-void
    :try_end
    .catch Ljava/lang/Throwable; {:try_start .. :try_end} :catch

    :catch
    sget-object v8, Landroid/os/BuildSpoof;->PROPS:Ljava/util/Properties;
    invoke-virtual {v8}, Ljava/util/Properties;->clear()V
    const/4 v8, 0x0
    sput-boolean v8, Landroid/os/BuildSpoof;->sLoaded:Z
    return-void

    :cond_done
    return-void
.end method

.method private static getAlias(Ljava/lang/String;)Ljava/lang/String;
    .registers 2
    const-string v0, "ro.product.manufacturer"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :cond_b
    const-string v0, "manufacturer"
    return-object v0
    :cond_b
    const-string v0, "ro.product.brand"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :cond_16
    const-string v0, "brand"
    return-object v0
    :cond_16
    const-string v0, "ro.product.model"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :cond_21
    const-string v0, "model"
    return-object v0
    :cond_21
    const-string v0, "ro.product.device"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :cond_2c
    const-string v0, "device"
    return-object v0
    :cond_2c
    const-string v0, "ro.product.name"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :cond_37
    const-string v0, "product"
    return-object v0
    :cond_37
    const-string v0, "ro.product.board"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :cond_42
    const-string v0, "board"
    return-object v0
    :cond_42
    const-string v0, "ro.build.fingerprint"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :cond_4d
    const-string v0, "fingerprint"
    return-object v0
    :cond_4d
    const-string v0, "ro.build.tags"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :cond_58
    const-string v0, "tags"
    return-object v0
    :cond_58
    const-string v0, "ro.build.type"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :cond_63
    const-string v0, "type"
    return-object v0
    :cond_63
    const-string v0, "ro.build.id"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :cond_6e
    const-string v0, "id"
    return-object v0
    :cond_6e
    const-string v0, "ro.build.display.id"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :cond_79
    const-string v0, "display"
    return-object v0
    :cond_79
    const-string v0, "ro.build.user"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :cond_84
    const-string v0, "user"
    return-object v0
    :cond_84
    const-string v0, "ro.build.host"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :cond_8f
    const-string v0, "host"
    return-object v0
    :cond_8f
    const-string v0, "ro.bootloader"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :cond_9a
    const-string v0, "bootloader"
    return-object v0
    :cond_9a
    const-string v0, "ro.hardware"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :cond_a5
    const-string v0, "hardware"
    return-object v0
    :cond_a5
    return-object p0
.end method

.method public static declared-synchronized get(Ljava/lang/String;)Ljava/lang/String;
    .registers 5
    invoke-static {}, Landroid/os/BuildSpoof;->load()V
    sget-object v0, Landroid/os/BuildSpoof;->PROPS:Ljava/util/Properties;
    invoke-virtual {v0, p0}, Ljava/util/Properties;->containsKey(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :cond_10
    invoke-virtual {v0, p0}, Ljava/util/Properties;->getProperty(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1
    return-object v1
    :cond_10
    invoke-static {p0}, Landroid/os/BuildSpoof;->getAlias(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1
    invoke-virtual {v0, v1}, Ljava/util/Properties;->containsKey(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :cond_1f
    invoke-virtual {v0, v1}, Ljava/util/Properties;->getProperty(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1
    return-object v1
    :cond_1f
    const-string v2, "ro.product."
    invoke-virtual {p0, v2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v2
    if-eqz v2, :cond_2f
    const/16 v2, 0xb
    invoke-virtual {p0, v2}, Ljava/lang/String;->substring(I)Ljava/lang/String;
    move-result-object v2
    invoke-virtual {v0, v2}, Ljava/util/Properties;->containsKey(Ljava/lang/Object;)Z
    move-result v3
    if-eqz v3, :cond_2f
    invoke-virtual {v0, v2}, Ljava/util/Properties;->getProperty(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1
    return-object v1
    :cond_2f
    const-string v2, "ro.build."
    invoke-virtual {p0, v2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v2
    if-eqz v2, :cond_3f
    const/16 v2, 0x9
    invoke-virtual {p0, v2}, Ljava/lang/String;->substring(I)Ljava/lang/String;
    move-result-object v2
    invoke-virtual {v0, v2}, Ljava/util/Properties;->containsKey(Ljava/lang/Object;)Z
    move-result v3
    if-eqz v3, :cond_3f
    invoke-virtual {v0, v2}, Ljava/util/Properties;->getProperty(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1
    return-object v1
    :cond_3f
    const/4 v0, 0x0
    return-object v0
.end method
