# classes3.dex

.class public Landroid/os/SemSystemProperties;
.super Ljava/lang/Object;
.source "SemSystemProperties.java"


# direct methods
.method private constructor blacklist <init>()V
    .registers 1

    .line 33
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 35
    return-void
.end method

.method public static whitelist get(Ljava/lang/String;)Ljava/lang/String;
    .registers 2
    .param p0, "key"  # Ljava/lang/String;

    .line 46
    invoke-static {p0}, Landroid/os/SystemProperties;->get(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public static whitelist get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .registers 3
    .param p0, "key"  # Ljava/lang/String;
    .param p1, "def"  # Ljava/lang/String;

    .line 59
    invoke-static {p0, p1}, Landroid/os/SystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public static whitelist getBoolean(Ljava/lang/String;Z)Z
    .registers 3
    .param p0, "key"  # Ljava/lang/String;
    .param p1, "def"  # Z

    .line 105
    invoke-static {p0, p1}, Landroid/os/SystemProperties;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    return v0
.end method

.method public static whitelist getCountryCode()Ljava/lang/String;
    .registers 2

    .line 146
    const-string/jumbo v0, "ro.csc.country_code"

    const-string v1, ""

    invoke-static {v0, v1}, Landroid/os/SystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public static whitelist getCountryIso()Ljava/lang/String;
    .registers 2

    .line 155
    const-string/jumbo v0, "ro.csc.countryiso_code"

    const-string v1, ""

    invoke-static {v0, v1}, Landroid/os/SystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public static blacklist getDeviceSerialNumber()Ljava/lang/String;
    .registers 2
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 127
    const-string v0, "serialnumber"

    invoke-static {v0}, Landroid/os/BuildSpoof;->get(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_serial_fallback

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_serial_fallback

    return-object v0

    :cond_serial_fallback
    const-string/jumbo v0, "ril.serialnumber"

    const-string v1, "00000000000"

    invoke-static {v0, v1}, Landroid/os/SystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public static whitelist getInt(Ljava/lang/String;I)I
    .registers 3
    .param p0, "key"  # Ljava/lang/String;
    .param p1, "def"  # I

    .line 72
    invoke-static {p0, p1}, Landroid/os/SystemProperties;->getInt(Ljava/lang/String;I)I

    move-result v0

    return v0
.end method

.method public static whitelist getLong(Ljava/lang/String;J)J
    .registers 5
    .param p0, "key"  # Ljava/lang/String;
    .param p1, "def"  # J

    .line 85
    invoke-static {p0, p1, p2}, Landroid/os/SystemProperties;->getLong(Ljava/lang/String;J)J

    move-result-wide v0

    return-wide v0
.end method

.method public static whitelist getSalesCode()Ljava/lang/String;
    .registers 2

    .line 137
    # BuildSpoof owns the Samsung-only decision. This keeps getSalesCode
    # isolated and avoids calling BuildSpoof recursively for manufacturer.
    const-string v0, "ro.csc.sales_code"
    invoke-static {v0}, Landroid/os/BuildSpoof;->get(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0

    if-eqz v0, :cond_sales_fallback
    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z
    move-result v1
    if-nez v1, :cond_sales_fallback
    return-object v0

    :cond_sales_fallback
    const-string/jumbo v0, "ro.csc.sales_code"
    const-string v1, ""
    invoke-static {v0, v1}, Landroid/os/SystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    return-object v0
.end method

.method public static whitelist set(Ljava/lang/String;Ljava/lang/String;)V
    .registers 2
    .param p0, "key"  # Ljava/lang/String;
    .param p1, "val"  # Ljava/lang/String;

    .line 115
    invoke-static {p0, p1}, Landroid/os/SystemProperties;->set(Ljava/lang/String;Ljava/lang/String;)V

    .line 116
    return-void
.end method
