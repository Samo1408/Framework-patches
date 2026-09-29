# classes3.dex
.class public final Landroid/os/BuildSpoof;
.super Ljava/lang/Object;
.source "BuildSpoof.java"

.field private static final FILE:Ljava/lang/String; = "/data/build.prop"
.field private static volatile PROPS:Ljava/util/Properties;
.field private static volatile sLastCheck:J
.field private static volatile sLastModified:J
.field private static volatile sLastLength:J
.field private static volatile sLoaded:Z

.method static constructor <clinit>()V
    .registers 3
    new-instance v0, Ljava/util/Properties;
    invoke-direct {v0}, Ljava/util/Properties;-><init>()V
    sput-object v0, Landroid/os/BuildSpoof;->PROPS:Ljava/util/Properties;
    const-wide/16 v1, 0x0
    sput-wide v1, Landroid/os/BuildSpoof;->sLastCheck:J
    sput-wide v1, Landroid/os/BuildSpoof;->sLastModified:J
    sput-wide v1, Landroid/os/BuildSpoof;->sLastLength:J
    const/4 v0, 0x0
    sput-boolean v0, Landroid/os/BuildSpoof;->sLoaded:Z
    return-void
.end method

.method private constructor <init>()V
    .registers 1
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method

.method private static load()V
    .registers 10
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J
    move-result-wide v0
    sget-wide v2, Landroid/os/BuildSpoof;->sLastCheck:J
    sub-long v4, v0, v2
    const-wide/32 v6, 0x4e20
    cmp-long v8, v4, v6
    if-ltz v8, :check
    return-void
:check
    sput-wide v0, Landroid/os/BuildSpoof;->sLastCheck:J
    new-instance v2, Ljava/io/File;
    const-string v3, "/data/build.prop"
    invoke-direct {v2, v3}, Ljava/io/File;-><init>(Ljava/lang/String;)V
    invoke-virtual {v2}, Ljava/io/File;->exists()Z
    move-result v8
    if-eqz v8, :missing
    invoke-virtual {v2}, Ljava/io/File;->lastModified()J
    move-result-wide v3
    invoke-virtual {v2}, Ljava/io/File;->length()J
    move-result-wide v5
    sget-boolean v8, Landroid/os/BuildSpoof;->sLoaded:Z
    if-eqz v8, :reload
    sget-wide v8, Landroid/os/BuildSpoof;->sLastModified:J
    cmp-long v8, v3, v8
    if-nez v8, :reload
    sget-wide v8, Landroid/os/BuildSpoof;->sLastLength:J
    cmp-long v8, v5, v8
    if-nez v8, :reload
    return-void
:reload
    :try_start
    new-instance v7, Ljava/io/FileInputStream;
    const-string v8, "/data/build.prop"
    invoke-direct {v7, v8}, Ljava/io/FileInputStream;-><init>(Ljava/lang/String;)V
    new-instance v8, Ljava/util/Properties;
    invoke-direct {v8}, Ljava/util/Properties;-><init>()V
    invoke-virtual {v8, v7}, Ljava/util/Properties;->load(Ljava/io/InputStream;)V
    invoke-virtual {v7}, Ljava/io/InputStream;->close()V
    sput-object v8, Landroid/os/BuildSpoof;->PROPS:Ljava/util/Properties;
    sput-wide v3, Landroid/os/BuildSpoof;->sLastModified:J
    sput-wide v5, Landroid/os/BuildSpoof;->sLastLength:J
    const/4 v8, 0x1
    sput-boolean v8, Landroid/os/BuildSpoof;->sLoaded:Z
    return-void
    :try_end
    .catch Ljava/lang/Throwable; {:try_start .. :try_end} :catch
:catch
    const/4 v8, 0x0
    sput-boolean v8, Landroid/os/BuildSpoof;->sLoaded:Z
    return-void
:missing
    new-instance v7, Ljava/util/Properties;
    invoke-direct {v7}, Ljava/util/Properties;-><init>()V
    sput-object v7, Landroid/os/BuildSpoof;->PROPS:Ljava/util/Properties;
    const-wide/16 v8, 0x0
    sput-wide v8, Landroid/os/BuildSpoof;->sLastModified:J
    sput-wide v8, Landroid/os/BuildSpoof;->sLastLength:J
    const/4 v8, 0x0
    sput-boolean v8, Landroid/os/BuildSpoof;->sLoaded:Z
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

    # Samsung-only Sales Code override. Keep the generic BuildSpoof path
    # unchanged for every other property so existing BuildSpoof hooks retain
    # their original behavior and 20-second reload semantics.
    const-string v1, "ro.csc.sales_code"
    invoke-virtual {v1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :cond_generic

    const-string v1, "manufacturer"
    invoke-virtual {v0, v1}, Ljava/util/Properties;->getProperty(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1
    if-eqz v1, :cond_sales_none

    const-string v2, "samsung"
    invoke-virtual {v2, v1}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z
    move-result v2
    if-eqz v2, :cond_sales_none

    const-string v1, "ro.csc.sales_code"
    invoke-virtual {v0, v1}, Ljava/util/Properties;->containsKey(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :cond_sales_none
    invoke-virtual {v0, v1}, Ljava/util/Properties;->getProperty(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1
    return-object v1

    :cond_sales_none
    const/4 v0, 0x0
    return-object v0

    :cond_generic
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
