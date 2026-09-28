.class public Landroid/location/Spoof;
.super Ljava/lang/Object;
.source "Spoof.java"


# static cache fields (battery/deep-sleep optimization)
.field private static sCountry:Ljava/lang/String;
.field private static sCountryTs:J
.field private static sLat:D
.field private static sLatTs:J
.field private static sLatValid:Z
.field private static sLon:D
.field private static sLonTs:J
.field private static sLonValid:Z
.field private static sOpNum:Ljava/lang/String;
.field private static sOpNumTs:J
.field private static sOpName:Ljava/lang/String;
.field private static sOpNameTs:J


# direct methods
.method public constructor <init>()V
    .registers 1
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method

.method private static getCountryImpl()Ljava/lang/String;
    .registers 4
    const-string v0, "ro.product.locale"
    const-string v1, "en-GB"
    invoke-static {v0, v1}, Landroid/os/BuildSpoof;->getOrSystemProperty(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    if-nez v0, :cond_ok
    const-string v0, "GB"
    return-object v0
    :cond_ok
    const/16 v1, 0x2d
    invoke-virtual {v0, v1}, Ljava/lang/String;->lastIndexOf(I)I
    move-result v1
    if-gez v1, :cond_has
    const-string v0, "GB"
    return-object v0
    :cond_has
    add-int/lit8 v1, v1, 0x1
    invoke-virtual {v0, v1}, Ljava/lang/String;->substring(I)Ljava/lang/String;
    move-result-object v0
    invoke-virtual {v0}, Ljava/lang/String;->toUpperCase()Ljava/lang/String;
    move-result-object v0
    return-object v0
.end method

.method public static getCountryIsoLower()Ljava/lang/String;
    .registers 2
    invoke-static {}, Landroid/location/Spoof;->getCountry()Ljava/lang/String;
    move-result-object v0
    invoke-virtual {v0}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;
    move-result-object v0
    return-object v0
.end method

.method public static getIdx(I)I
    .registers 6
    .param p0, "size"
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J
    move-result-wide v0
    const-wide/32 v2, 0x927c0
    div-long/2addr v0, v2
    int-to-long v2, p0
    rem-long/2addr v0, v2
    long-to-int v0, v0
    if-gez v0, :pos
    neg-int v0, v0
    :pos
    return v0
.end method

.method public static getSpeed()F
    .registers 3
    const-string v0, "1.4"
    invoke-static {v0}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D
    move-result-wide v0
    double-to-float v2, v0
    return v2
.end method


.method public static latUS(I)D
    .registers 4
    .param p0, "i"

    packed-switch p0, :pd
    :case_0
    const-string v0, "40.764971"
    goto :parse
    :case_1
    const-string v0, "40.746751"
    goto :parse
    :case_2
    const-string v0, "40.769824"
    goto :parse
    :case_3
    const-string v0, "40.777609"
    goto :parse
    :case_4
    const-string v0, "40.754096"
    goto :parse
    :case_5
    const-string v0, "40.743932"
    goto :parse
    :case_6
    const-string v0, "40.734327"
    goto :parse
    :case_7
    const-string v0, "40.765494"
    goto :parse
    :case_8
    const-string v0, "40.744022"
    goto :parse
    :case_9
    const-string v0, "40.773472"
    goto :parse
    :case_10
    const-string v0, "40.773291"
    goto :parse
    :case_11
    const-string v0, "40.750013"
    goto :parse
    :case_12
    const-string v0, "40.780861"
    goto :parse
    :case_13
    const-string v0, "40.737637"
    goto :parse
    :case_14
    const-string v0, "40.775375"
    goto :parse
    :case_15
    const-string v0, "40.773356"
    goto :parse
    :case_16
    const-string v0, "40.759811"
    goto :parse
    :case_17
    const-string v0, "40.751927"
    goto :parse
    :case_18
    const-string v0, "40.774470"
    goto :parse
    :case_19
    const-string v0, "40.776085"
    goto :parse
    :parse
    invoke-static {v0}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D
    move-result-wide v2
    return-wide v2
    :pd
    .packed-switch 0x0
        :case_0
        :case_1
        :case_2
        :case_3
        :case_4
        :case_5
        :case_6
        :case_7
        :case_8
        :case_9
        :case_10
        :case_11
        :case_12
        :case_13
        :case_14
        :case_15
        :case_16
        :case_17
        :case_18
        :case_19
    .end packed-switch
.end method

.method public static lonUS(I)D
    .registers 4
    .param p0, "i"

    packed-switch p0, :pd
    :case_0
    const-string v0, "-74.009249"
    goto :parse
    :case_1
    const-string v0, "-73.999339"
    goto :parse
    :case_2
    const-string v0, "-73.976665"
    goto :parse
    :case_3
    const-string v0, "-74.006153"
    goto :parse
    :case_4
    const-string v0, "-74.009010"
    goto :parse
    :case_5
    const-string v0, "-73.985232"
    goto :parse
    :case_6
    const-string v0, "-74.000558"
    goto :parse
    :case_7
    const-string v0, "-73.983253"
    goto :parse
    :case_8
    const-string v0, "-73.981037"
    goto :parse
    :case_9
    const-string v0, "-74.010175"
    goto :parse
    :case_10
    const-string v0, "-73.975593"
    goto :parse
    :case_11
    const-string v0, "-74.002726"
    goto :parse
    :case_12
    const-string v0, "-73.993670"
    goto :parse
    :case_13
    const-string v0, "-74.005664"
    goto :parse
    :case_14
    const-string v0, "-73.980314"
    goto :parse
    :case_15
    const-string v0, "-73.974013"
    goto :parse
    :case_16
    const-string v0, "-73.961844"
    goto :parse
    :case_17
    const-string v0, "-73.982898"
    goto :parse
    :case_18
    const-string v0, "-73.979574"
    goto :parse
    :case_19
    const-string v0, "-73.981632"
    goto :parse
    :parse
    invoke-static {v0}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D
    move-result-wide v2
    return-wide v2
    :pd
    .packed-switch 0x0
        :case_0
        :case_1
        :case_2
        :case_3
        :case_4
        :case_5
        :case_6
        :case_7
        :case_8
        :case_9
        :case_10
        :case_11
        :case_12
        :case_13
        :case_14
        :case_15
        :case_16
        :case_17
        :case_18
        :case_19
    .end packed-switch
.end method

.method public static numUS(I)Ljava/lang/String;
    .registers 2
    .param p0, "i"

    packed-switch p0, :pd
    :case_0
    const-string v0, "310260"
    return-object v0
    :case_1
    const-string v0, "310410"
    return-object v0
    :case_2
    const-string v0, "310004"
    return-object v0
    const-string v0, ""
    return-object v0
    :pd
    .packed-switch 0x0
        :case_0
        :case_1
        :case_2
    .end packed-switch
.end method

.method public static namUS(I)Ljava/lang/String;
    .registers 2
    .param p0, "i"

    packed-switch p0, :pd
    :case_0
    const-string v0, "T-Mobile"
    return-object v0
    :case_1
    const-string v0, "AT&T"
    return-object v0
    :case_2
    const-string v0, "Verizon"
    return-object v0
    const-string v0, ""
    return-object v0
    :pd
    .packed-switch 0x0
        :case_0
        :case_1
        :case_2
    .end packed-switch
.end method

.method public static latDE(I)D
    .registers 4
    .param p0, "i"

    packed-switch p0, :pd
    :case_0
    const-string v0, "52.530229"
    goto :parse
    :case_1
    const-string v0, "52.506395"
    goto :parse
    :case_2
    const-string v0, "52.498990"
    goto :parse
    :case_3
    const-string v0, "52.500050"
    goto :parse
    :case_4
    const-string v0, "52.526784"
    goto :parse
    :case_5
    const-string v0, "52.513509"
    goto :parse
    :case_6
    const-string v0, "52.508349"
    goto :parse
    :case_7
    const-string v0, "52.527402"
    goto :parse
    :case_8
    const-string v0, "52.503557"
    goto :parse
    :case_9
    const-string v0, "52.503170"
    goto :parse
    :case_10
    const-string v0, "52.544476"
    goto :parse
    :case_11
    const-string v0, "52.522847"
    goto :parse
    :case_12
    const-string v0, "52.537143"
    goto :parse
    :case_13
    const-string v0, "52.506452"
    goto :parse
    :case_14
    const-string v0, "52.510773"
    goto :parse
    :case_15
    const-string v0, "52.505549"
    goto :parse
    :case_16
    const-string v0, "52.538818"
    goto :parse
    :case_17
    const-string v0, "52.527772"
    goto :parse
    :case_18
    const-string v0, "52.540727"
    goto :parse
    :case_19
    const-string v0, "52.508244"
    goto :parse
    :parse
    invoke-static {v0}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D
    move-result-wide v2
    return-wide v2
    :pd
    .packed-switch 0x0
        :case_0
        :case_1
        :case_2
        :case_3
        :case_4
        :case_5
        :case_6
        :case_7
        :case_8
        :case_9
        :case_10
        :case_11
        :case_12
        :case_13
        :case_14
        :case_15
        :case_16
        :case_17
        :case_18
        :case_19
    .end packed-switch
.end method

.method public static lonDE(I)D
    .registers 4
    .param p0, "i"

    packed-switch p0, :pd
    :case_0
    const-string v0, "13.382291"
    goto :parse
    :case_1
    const-string v0, "13.394469"
    goto :parse
    :case_2
    const-string v0, "13.391640"
    goto :parse
    :case_3
    const-string v0, "13.393899"
    goto :parse
    :case_4
    const-string v0, "13.398242"
    goto :parse
    :case_5
    const-string v0, "13.390475"
    goto :parse
    :case_6
    const-string v0, "13.426833"
    goto :parse
    :case_7
    const-string v0, "13.410457"
    goto :parse
    :case_8
    const-string v0, "13.416456"
    goto :parse
    :case_9
    const-string v0, "13.398973"
    goto :parse
    :case_10
    const-string v0, "13.412000"
    goto :parse
    :case_11
    const-string v0, "13.414231"
    goto :parse
    :case_12
    const-string v0, "13.418800"
    goto :parse
    :case_13
    const-string v0, "13.381605"
    goto :parse
    :case_14
    const-string v0, "13.393387"
    goto :parse
    :case_15
    const-string v0, "13.427145"
    goto :parse
    :case_16
    const-string v0, "13.395734"
    goto :parse
    :case_17
    const-string v0, "13.399782"
    goto :parse
    :case_18
    const-string v0, "13.402943"
    goto :parse
    :case_19
    const-string v0, "13.392331"
    goto :parse
    :parse
    invoke-static {v0}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D
    move-result-wide v2
    return-wide v2
    :pd
    .packed-switch 0x0
        :case_0
        :case_1
        :case_2
        :case_3
        :case_4
        :case_5
        :case_6
        :case_7
        :case_8
        :case_9
        :case_10
        :case_11
        :case_12
        :case_13
        :case_14
        :case_15
        :case_16
        :case_17
        :case_18
        :case_19
    .end packed-switch
.end method

.method public static numDE(I)Ljava/lang/String;
    .registers 2
    .param p0, "i"

    packed-switch p0, :pd
    :case_0
    const-string v0, "26201"
    return-object v0
    :case_1
    const-string v0, "26202"
    return-object v0
    :case_2
    const-string v0, "26207"
    return-object v0
    const-string v0, ""
    return-object v0
    :pd
    .packed-switch 0x0
        :case_0
        :case_1
        :case_2
    .end packed-switch
.end method

.method public static namDE(I)Ljava/lang/String;
    .registers 2
    .param p0, "i"

    packed-switch p0, :pd
    :case_0
    const-string v0, "Telekom.de"
    return-object v0
    :case_1
    const-string v0, "Vodafone.de"
    return-object v0
    :case_2
    const-string v0, "o2 - de"
    return-object v0
    const-string v0, ""
    return-object v0
    :pd
    .packed-switch 0x0
        :case_0
        :case_1
        :case_2
    .end packed-switch
.end method

.method public static latGB(I)D
    .registers 4
    .param p0, "i"

    packed-switch p0, :pd
    :case_0
    const-string v0, "51.510468"
    goto :parse
    :case_1
    const-string v0, "51.511629"
    goto :parse
    :case_2
    const-string v0, "51.502370"
    goto :parse
    :case_3
    const-string v0, "51.532277"
    goto :parse
    :case_4
    const-string v0, "51.486945"
    goto :parse
    :case_5
    const-string v0, "51.487882"
    goto :parse
    :case_6
    const-string v0, "51.522004"
    goto :parse
    :case_7
    const-string v0, "51.485576"
    goto :parse
    :case_8
    const-string v0, "51.532206"
    goto :parse
    :case_9
    const-string v0, "51.530954"
    goto :parse
    :case_10
    const-string v0, "51.482974"
    goto :parse
    :case_11
    const-string v0, "51.516486"
    goto :parse
    :case_12
    const-string v0, "51.495741"
    goto :parse
    :case_13
    const-string v0, "51.487978"
    goto :parse
    :case_14
    const-string v0, "51.505086"
    goto :parse
    :case_15
    const-string v0, "51.526193"
    goto :parse
    :case_16
    const-string v0, "51.507429"
    goto :parse
    :case_17
    const-string v0, "51.528031"
    goto :parse
    :case_18
    const-string v0, "51.497322"
    goto :parse
    :case_19
    const-string v0, "51.512849"
    goto :parse
    :parse
    invoke-static {v0}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D
    move-result-wide v2
    return-wide v2
    :pd
    .packed-switch 0x0
        :case_0
        :case_1
        :case_2
        :case_3
        :case_4
        :case_5
        :case_6
        :case_7
        :case_8
        :case_9
        :case_10
        :case_11
        :case_12
        :case_13
        :case_14
        :case_15
        :case_16
        :case_17
        :case_18
        :case_19
    .end packed-switch
.end method

.method public static lonGB(I)D
    .registers 4
    .param p0, "i"

    packed-switch p0, :pd
    :case_0
    const-string v0, "-0.139663"
    goto :parse
    :case_1
    const-string v0, "-0.107909"
    goto :parse
    :case_2
    const-string v0, "-0.141834"
    goto :parse
    :case_3
    const-string v0, "-0.127324"
    goto :parse
    :case_4
    const-string v0, "-0.150444"
    goto :parse
    :case_5
    const-string v0, "-0.121428"
    goto :parse
    :case_6
    const-string v0, "-0.131692"
    goto :parse
    :case_7
    const-string v0, "-0.133719"
    goto :parse
    :case_8
    const-string v0, "-0.126344"
    goto :parse
    :case_9
    const-string v0, "-0.109761"
    goto :parse
    :case_10
    const-string v0, "-0.116764"
    goto :parse
    :case_11
    const-string v0, "-0.125951"
    goto :parse
    :case_12
    const-string v0, "-0.120752"
    goto :parse
    :case_13
    const-string v0, "-0.131062"
    goto :parse
    :case_14
    const-string v0, "-0.105109"
    goto :parse
    :case_15
    const-string v0, "-0.139631"
    goto :parse
    :case_16
    const-string v0, "-0.143867"
    goto :parse
    :case_17
    const-string v0, "-0.109274"
    goto :parse
    :case_18
    const-string v0, "-0.120853"
    goto :parse
    :case_19
    const-string v0, "-0.145158"
    goto :parse
    :parse
    invoke-static {v0}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D
    move-result-wide v2
    return-wide v2
    :pd
    .packed-switch 0x0
        :case_0
        :case_1
        :case_2
        :case_3
        :case_4
        :case_5
        :case_6
        :case_7
        :case_8
        :case_9
        :case_10
        :case_11
        :case_12
        :case_13
        :case_14
        :case_15
        :case_16
        :case_17
        :case_18
        :case_19
    .end packed-switch
.end method

.method public static numGB(I)Ljava/lang/String;
    .registers 2
    .param p0, "i"

    packed-switch p0, :pd
    :case_0
    const-string v0, "23430"
    return-object v0
    :case_1
    const-string v0, "23415"
    return-object v0
    :case_2
    const-string v0, "23410"
    return-object v0
    const-string v0, ""
    return-object v0
    :pd
    .packed-switch 0x0
        :case_0
        :case_1
        :case_2
    .end packed-switch
.end method

.method public static namGB(I)Ljava/lang/String;
    .registers 2
    .param p0, "i"

    packed-switch p0, :pd
    :case_0
    const-string v0, "EE"
    return-object v0
    :case_1
    const-string v0, "Vodafone UK"
    return-object v0
    :case_2
    const-string v0, "O2 - UK"
    return-object v0
    const-string v0, ""
    return-object v0
    :pd
    .packed-switch 0x0
        :case_0
        :case_1
        :case_2
    .end packed-switch
.end method

.method public static latCA(I)D
    .registers 4
    .param p0, "i"

    packed-switch p0, :pd
    :case_0
    const-string v0, "43.666326"
    goto :parse
    :case_1
    const-string v0, "43.667131"
    goto :parse
    :case_2
    const-string v0, "43.628229"
    goto :parse
    :case_3
    const-string v0, "43.629174"
    goto :parse
    :case_4
    const-string v0, "43.672136"
    goto :parse
    :case_5
    const-string v0, "43.643576"
    goto :parse
    :case_6
    const-string v0, "43.672100"
    goto :parse
    :case_7
    const-string v0, "43.632483"
    goto :parse
    :case_8
    const-string v0, "43.631661"
    goto :parse
    :case_9
    const-string v0, "43.666492"
    goto :parse
    :case_10
    const-string v0, "43.651964"
    goto :parse
    :case_11
    const-string v0, "43.641453"
    goto :parse
    :case_12
    const-string v0, "43.649357"
    goto :parse
    :case_13
    const-string v0, "43.655165"
    goto :parse
    :case_14
    const-string v0, "43.638258"
    goto :parse
    :case_15
    const-string v0, "43.677957"
    goto :parse
    :case_16
    const-string v0, "43.650105"
    goto :parse
    :case_17
    const-string v0, "43.634250"
    goto :parse
    :case_18
    const-string v0, "43.645104"
    goto :parse
    :case_19
    const-string v0, "43.639706"
    goto :parse
    :parse
    invoke-static {v0}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D
    move-result-wide v2
    return-wide v2
    :pd
    .packed-switch 0x0
        :case_0
        :case_1
        :case_2
        :case_3
        :case_4
        :case_5
        :case_6
        :case_7
        :case_8
        :case_9
        :case_10
        :case_11
        :case_12
        :case_13
        :case_14
        :case_15
        :case_16
        :case_17
        :case_18
        :case_19
    .end packed-switch
.end method

.method public static lonCA(I)D
    .registers 4
    .param p0, "i"

    packed-switch p0, :pd
    :case_0
    const-string v0, "-79.381231"
    goto :parse
    :case_1
    const-string v0, "-79.381682"
    goto :parse
    :case_2
    const-string v0, "-79.391992"
    goto :parse
    :case_3
    const-string v0, "-79.361745"
    goto :parse
    :case_4
    const-string v0, "-79.366617"
    goto :parse
    :case_5
    const-string v0, "-79.405304"
    goto :parse
    :case_6
    const-string v0, "-79.360853"
    goto :parse
    :case_7
    const-string v0, "-79.383900"
    goto :parse
    :case_8
    const-string v0, "-79.370170"
    goto :parse
    :case_9
    const-string v0, "-79.401780"
    goto :parse
    :case_10
    const-string v0, "-79.380710"
    goto :parse
    :case_11
    const-string v0, "-79.364578"
    goto :parse
    :case_12
    const-string v0, "-79.397610"
    goto :parse
    :case_13
    const-string v0, "-79.371703"
    goto :parse
    :case_14
    const-string v0, "-79.392614"
    goto :parse
    :case_15
    const-string v0, "-79.375706"
    goto :parse
    :case_16
    const-string v0, "-79.382321"
    goto :parse
    :case_17
    const-string v0, "-79.396965"
    goto :parse
    :case_18
    const-string v0, "-79.378785"
    goto :parse
    :case_19
    const-string v0, "-79.397189"
    goto :parse
    :parse
    invoke-static {v0}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D
    move-result-wide v2
    return-wide v2
    :pd
    .packed-switch 0x0
        :case_0
        :case_1
        :case_2
        :case_3
        :case_4
        :case_5
        :case_6
        :case_7
        :case_8
        :case_9
        :case_10
        :case_11
        :case_12
        :case_13
        :case_14
        :case_15
        :case_16
        :case_17
        :case_18
        :case_19
    .end packed-switch
.end method

.method public static numCA(I)Ljava/lang/String;
    .registers 2
    .param p0, "i"

    packed-switch p0, :pd
    :case_0
    const-string v0, "302720"
    return-object v0
    :case_1
    const-string v0, "302610"
    return-object v0
    :case_2
    const-string v0, "302220"
    return-object v0
    const-string v0, ""
    return-object v0
    :pd
    .packed-switch 0x0
        :case_0
        :case_1
        :case_2
    .end packed-switch
.end method

.method public static namCA(I)Ljava/lang/String;
    .registers 2
    .param p0, "i"

    packed-switch p0, :pd
    :case_0
    const-string v0, "Rogers"
    return-object v0
    :case_1
    const-string v0, "Bell"
    return-object v0
    :case_2
    const-string v0, "TELUS"
    return-object v0
    const-string v0, ""
    return-object v0
    :pd
    .packed-switch 0x0
        :case_0
        :case_1
        :case_2
    .end packed-switch
.end method

.method public static latAT(I)D
    .registers 4
    .param p0, "i"

    packed-switch p0, :pd
    :case_0
    const-string v0, "48.186750"
    goto :parse
    :case_1
    const-string v0, "48.194647"
    goto :parse
    :case_2
    const-string v0, "48.226182"
    goto :parse
    :case_3
    const-string v0, "48.195100"
    goto :parse
    :case_4
    const-string v0, "48.193912"
    goto :parse
    :case_5
    const-string v0, "48.229976"
    goto :parse
    :case_6
    const-string v0, "48.206834"
    goto :parse
    :case_7
    const-string v0, "48.223575"
    goto :parse
    :case_8
    const-string v0, "48.188047"
    goto :parse
    :case_9
    const-string v0, "48.204379"
    goto :parse
    :case_10
    const-string v0, "48.219654"
    goto :parse
    :case_11
    const-string v0, "48.232408"
    goto :parse
    :case_12
    const-string v0, "48.203331"
    goto :parse
    :case_13
    const-string v0, "48.226284"
    goto :parse
    :case_14
    const-string v0, "48.192710"
    goto :parse
    :case_15
    const-string v0, "48.204294"
    goto :parse
    :case_16
    const-string v0, "48.195690"
    goto :parse
    :case_17
    const-string v0, "48.205357"
    goto :parse
    :case_18
    const-string v0, "48.210716"
    goto :parse
    :case_19
    const-string v0, "48.233164"
    goto :parse
    :parse
    invoke-static {v0}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D
    move-result-wide v2
    return-wide v2
    :pd
    .packed-switch 0x0
        :case_0
        :case_1
        :case_2
        :case_3
        :case_4
        :case_5
        :case_6
        :case_7
        :case_8
        :case_9
        :case_10
        :case_11
        :case_12
        :case_13
        :case_14
        :case_15
        :case_16
        :case_17
        :case_18
        :case_19
    .end packed-switch
.end method

.method public static lonAT(I)D
    .registers 4
    .param p0, "i"

    packed-switch p0, :pd
    :case_0
    const-string v0, "16.380355"
    goto :parse
    :case_1
    const-string v0, "16.394071"
    goto :parse
    :case_2
    const-string v0, "16.352343"
    goto :parse
    :case_3
    const-string v0, "16.382249"
    goto :parse
    :case_4
    const-string v0, "16.355416"
    goto :parse
    :case_5
    const-string v0, "16.377352"
    goto :parse
    :case_6
    const-string v0, "16.388031"
    goto :parse
    :case_7
    const-string v0, "16.358320"
    goto :parse
    :case_8
    const-string v0, "16.370353"
    goto :parse
    :case_9
    const-string v0, "16.372151"
    goto :parse
    :case_10
    const-string v0, "16.382468"
    goto :parse
    :case_11
    const-string v0, "16.353721"
    goto :parse
    :case_12
    const-string v0, "16.365765"
    goto :parse
    :case_13
    const-string v0, "16.361233"
    goto :parse
    :case_14
    const-string v0, "16.371231"
    goto :parse
    :case_15
    const-string v0, "16.362727"
    goto :parse
    :case_16
    const-string v0, "16.394963"
    goto :parse
    :case_17
    const-string v0, "16.391867"
    goto :parse
    :case_18
    const-string v0, "16.351329"
    goto :parse
    :case_19
    const-string v0, "16.390601"
    goto :parse
    :parse
    invoke-static {v0}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D
    move-result-wide v2
    return-wide v2
    :pd
    .packed-switch 0x0
        :case_0
        :case_1
        :case_2
        :case_3
        :case_4
        :case_5
        :case_6
        :case_7
        :case_8
        :case_9
        :case_10
        :case_11
        :case_12
        :case_13
        :case_14
        :case_15
        :case_16
        :case_17
        :case_18
        :case_19
    .end packed-switch
.end method

.method public static numAT(I)Ljava/lang/String;
    .registers 2
    .param p0, "i"

    packed-switch p0, :pd
    :case_0
    const-string v0, "23201"
    return-object v0
    :case_1
    const-string v0, "23203"
    return-object v0
    :case_2
    const-string v0, "23210"
    return-object v0
    const-string v0, ""
    return-object v0
    :pd
    .packed-switch 0x0
        :case_0
        :case_1
        :case_2
    .end packed-switch
.end method

.method public static namAT(I)Ljava/lang/String;
    .registers 2
    .param p0, "i"

    packed-switch p0, :pd
    :case_0
    const-string v0, "A1"
    return-object v0
    :case_1
    const-string v0, "Magenta"
    return-object v0
    :case_2
    const-string v0, "Drei"
    return-object v0
    const-string v0, ""
    return-object v0
    :pd
    .packed-switch 0x0
        :case_0
        :case_1
        :case_2
    .end packed-switch
.end method

.method public static latAU(I)D
    .registers 4
    .param p0, "i"

    packed-switch p0, :pd
    :case_0
    const-string v0, "-33.845350"
    goto :parse
    :case_1
    const-string v0, "-33.851365"
    goto :parse
    :case_2
    const-string v0, "-33.869518"
    goto :parse
    :case_3
    const-string v0, "-33.873748"
    goto :parse
    :case_4
    const-string v0, "-33.874851"
    goto :parse
    :case_5
    const-string v0, "-33.880540"
    goto :parse
    :case_6
    const-string v0, "-33.871050"
    goto :parse
    :case_7
    const-string v0, "-33.845934"
    goto :parse
    :case_8
    const-string v0, "-33.866012"
    goto :parse
    :case_9
    const-string v0, "-33.886060"
    goto :parse
    :case_10
    const-string v0, "-33.845365"
    goto :parse
    :case_11
    const-string v0, "-33.866690"
    goto :parse
    :case_12
    const-string v0, "-33.890942"
    goto :parse
    :case_13
    const-string v0, "-33.868657"
    goto :parse
    :case_14
    const-string v0, "-33.885928"
    goto :parse
    :case_15
    const-string v0, "-33.889794"
    goto :parse
    :case_16
    const-string v0, "-33.864048"
    goto :parse
    :case_17
    const-string v0, "-33.882040"
    goto :parse
    :case_18
    const-string v0, "-33.849286"
    goto :parse
    :case_19
    const-string v0, "-33.864074"
    goto :parse
    :parse
    invoke-static {v0}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D
    move-result-wide v2
    return-wide v2
    :pd
    .packed-switch 0x0
        :case_0
        :case_1
        :case_2
        :case_3
        :case_4
        :case_5
        :case_6
        :case_7
        :case_8
        :case_9
        :case_10
        :case_11
        :case_12
        :case_13
        :case_14
        :case_15
        :case_16
        :case_17
        :case_18
        :case_19
    .end packed-switch
.end method

.method public static lonAU(I)D
    .registers 4
    .param p0, "i"

    packed-switch p0, :pd
    :case_0
    const-string v0, "151.230618"
    goto :parse
    :case_1
    const-string v0, "151.192616"
    goto :parse
    :case_2
    const-string v0, "151.194987"
    goto :parse
    :case_3
    const-string v0, "151.187232"
    goto :parse
    :case_4
    const-string v0, "151.233565"
    goto :parse
    :case_5
    const-string v0, "151.223504"
    goto :parse
    :case_6
    const-string v0, "151.205450"
    goto :parse
    :case_7
    const-string v0, "151.234071"
    goto :parse
    :case_8
    const-string v0, "151.220220"
    goto :parse
    :case_9
    const-string v0, "151.199135"
    goto :parse
    :case_10
    const-string v0, "151.213259"
    goto :parse
    :case_11
    const-string v0, "151.221699"
    goto :parse
    :case_12
    const-string v0, "151.213509"
    goto :parse
    :case_13
    const-string v0, "151.226936"
    goto :parse
    :case_14
    const-string v0, "151.232339"
    goto :parse
    :case_15
    const-string v0, "151.193591"
    goto :parse
    :case_16
    const-string v0, "151.218061"
    goto :parse
    :case_17
    const-string v0, "151.190294"
    goto :parse
    :case_18
    const-string v0, "151.196611"
    goto :parse
    :case_19
    const-string v0, "151.215269"
    goto :parse
    :parse
    invoke-static {v0}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D
    move-result-wide v2
    return-wide v2
    :pd
    .packed-switch 0x0
        :case_0
        :case_1
        :case_2
        :case_3
        :case_4
        :case_5
        :case_6
        :case_7
        :case_8
        :case_9
        :case_10
        :case_11
        :case_12
        :case_13
        :case_14
        :case_15
        :case_16
        :case_17
        :case_18
        :case_19
    .end packed-switch
.end method

.method public static numAU(I)Ljava/lang/String;
    .registers 2
    .param p0, "i"

    packed-switch p0, :pd
    :case_0
    const-string v0, "50501"
    return-object v0
    :case_1
    const-string v0, "50502"
    return-object v0
    :case_2
    const-string v0, "50503"
    return-object v0
    const-string v0, ""
    return-object v0
    :pd
    .packed-switch 0x0
        :case_0
        :case_1
        :case_2
    .end packed-switch
.end method

.method public static namAU(I)Ljava/lang/String;
    .registers 2
    .param p0, "i"

    packed-switch p0, :pd
    :case_0
    const-string v0, "Telstra"
    return-object v0
    :case_1
    const-string v0, "Optus"
    return-object v0
    :case_2
    const-string v0, "Vodafone AU"
    return-object v0
    const-string v0, ""
    return-object v0
    :pd
    .packed-switch 0x0
        :case_0
        :case_1
        :case_2
    .end packed-switch
.end method

.method public static latCH(I)D
    .registers 4
    .param p0, "i"

    packed-switch p0, :pd
    :case_0
    const-string v0, "47.372861"
    goto :parse
    :case_1
    const-string v0, "47.378039"
    goto :parse
    :case_2
    const-string v0, "47.362113"
    goto :parse
    :case_3
    const-string v0, "47.363834"
    goto :parse
    :case_4
    const-string v0, "47.385485"
    goto :parse
    :case_5
    const-string v0, "47.367709"
    goto :parse
    :case_6
    const-string v0, "47.355527"
    goto :parse
    :case_7
    const-string v0, "47.401823"
    goto :parse
    :case_8
    const-string v0, "47.355563"
    goto :parse
    :case_9
    const-string v0, "47.365160"
    goto :parse
    :case_10
    const-string v0, "47.395943"
    goto :parse
    :case_11
    const-string v0, "47.370376"
    goto :parse
    :case_12
    const-string v0, "47.393587"
    goto :parse
    :case_13
    const-string v0, "47.382484"
    goto :parse
    :case_14
    const-string v0, "47.384599"
    goto :parse
    :case_15
    const-string v0, "47.392755"
    goto :parse
    :case_16
    const-string v0, "47.385069"
    goto :parse
    :case_17
    const-string v0, "47.358615"
    goto :parse
    :case_18
    const-string v0, "47.357252"
    goto :parse
    :case_19
    const-string v0, "47.365517"
    goto :parse
    :parse
    invoke-static {v0}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D
    move-result-wide v2
    return-wide v2
    :pd
    .packed-switch 0x0
        :case_0
        :case_1
        :case_2
        :case_3
        :case_4
        :case_5
        :case_6
        :case_7
        :case_8
        :case_9
        :case_10
        :case_11
        :case_12
        :case_13
        :case_14
        :case_15
        :case_16
        :case_17
        :case_18
        :case_19
    .end packed-switch
.end method

.method public static lonCH(I)D
    .registers 4
    .param p0, "i"

    packed-switch p0, :pd
    :case_0
    const-string v0, "8.545884"
    goto :parse
    :case_1
    const-string v0, "8.563435"
    goto :parse
    :case_2
    const-string v0, "8.552510"
    goto :parse
    :case_3
    const-string v0, "8.536489"
    goto :parse
    :case_4
    const-string v0, "8.531700"
    goto :parse
    :case_5
    const-string v0, "8.554293"
    goto :parse
    :case_6
    const-string v0, "8.539614"
    goto :parse
    :case_7
    const-string v0, "8.566505"
    goto :parse
    :case_8
    const-string v0, "8.527358"
    goto :parse
    :case_9
    const-string v0, "8.563363"
    goto :parse
    :case_10
    const-string v0, "8.560664"
    goto :parse
    :case_11
    const-string v0, "8.524587"
    goto :parse
    :case_12
    const-string v0, "8.551877"
    goto :parse
    :case_13
    const-string v0, "8.566062"
    goto :parse
    :case_14
    const-string v0, "8.517091"
    goto :parse
    :case_15
    const-string v0, "8.531669"
    goto :parse
    :case_16
    const-string v0, "8.563647"
    goto :parse
    :case_17
    const-string v0, "8.522471"
    goto :parse
    :case_18
    const-string v0, "8.544361"
    goto :parse
    :case_19
    const-string v0, "8.546941"
    goto :parse
    :parse
    invoke-static {v0}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D
    move-result-wide v2
    return-wide v2
    :pd
    .packed-switch 0x0
        :case_0
        :case_1
        :case_2
        :case_3
        :case_4
        :case_5
        :case_6
        :case_7
        :case_8
        :case_9
        :case_10
        :case_11
        :case_12
        :case_13
        :case_14
        :case_15
        :case_16
        :case_17
        :case_18
        :case_19
    .end packed-switch
.end method

.method public static numCH(I)Ljava/lang/String;
    .registers 2
    .param p0, "i"

    packed-switch p0, :pd
    :case_0
    const-string v0, "22801"
    return-object v0
    :case_1
    const-string v0, "22802"
    return-object v0
    :case_2
    const-string v0, "22803"
    return-object v0
    const-string v0, ""
    return-object v0
    :pd
    .packed-switch 0x0
        :case_0
        :case_1
        :case_2
    .end packed-switch
.end method

.method public static namCH(I)Ljava/lang/String;
    .registers 2
    .param p0, "i"

    packed-switch p0, :pd
    :case_0
    const-string v0, "Swisscom"
    return-object v0
    :case_1
    const-string v0, "Sunrise"
    return-object v0
    :case_2
    const-string v0, "Salt"
    return-object v0
    const-string v0, ""
    return-object v0
    :pd
    .packed-switch 0x0
        :case_0
        :case_1
        :case_2
    .end packed-switch
.end method

.method public static latKR(I)D
    .registers 4
    .param p0, "i"

    packed-switch p0, :pd
    :case_0
    const-string v0, "37.577381"
    goto :parse
    :case_1
    const-string v0, "37.573212"
    goto :parse
    :case_2
    const-string v0, "37.565927"
    goto :parse
    :case_3
    const-string v0, "37.583805"
    goto :parse
    :case_4
    const-string v0, "37.562679"
    goto :parse
    :case_5
    const-string v0, "37.541677"
    goto :parse
    :case_6
    const-string v0, "37.573356"
    goto :parse
    :case_7
    const-string v0, "37.578562"
    goto :parse
    :case_8
    const-string v0, "37.562884"
    goto :parse
    :case_9
    const-string v0, "37.545262"
    goto :parse
    :case_10
    const-string v0, "37.586696"
    goto :parse
    :case_11
    const-string v0, "37.583230"
    goto :parse
    :case_12
    const-string v0, "37.548905"
    goto :parse
    :case_13
    const-string v0, "37.556913"
    goto :parse
    :case_14
    const-string v0, "37.581306"
    goto :parse
    :case_15
    const-string v0, "37.586446"
    goto :parse
    :case_16
    const-string v0, "37.553976"
    goto :parse
    :case_17
    const-string v0, "37.580506"
    goto :parse
    :case_18
    const-string v0, "37.561819"
    goto :parse
    :case_19
    const-string v0, "37.549228"
    goto :parse
    :parse
    invoke-static {v0}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D
    move-result-wide v2
    return-wide v2
    :pd
    .packed-switch 0x0
        :case_0
        :case_1
        :case_2
        :case_3
        :case_4
        :case_5
        :case_6
        :case_7
        :case_8
        :case_9
        :case_10
        :case_11
        :case_12
        :case_13
        :case_14
        :case_15
        :case_16
        :case_17
        :case_18
        :case_19
    .end packed-switch
.end method

.method public static lonKR(I)D
    .registers 4
    .param p0, "i"

    packed-switch p0, :pd
    :case_0
    const-string v0, "126.963180"
    goto :parse
    :case_1
    const-string v0, "126.966199"
    goto :parse
    :case_2
    const-string v0, "126.998267"
    goto :parse
    :case_3
    const-string v0, "126.957615"
    goto :parse
    :case_4
    const-string v0, "126.966834"
    goto :parse
    :case_5
    const-string v0, "126.991556"
    goto :parse
    :case_6
    const-string v0, "126.966098"
    goto :parse
    :case_7
    const-string v0, "126.980584"
    goto :parse
    :case_8
    const-string v0, "126.953483"
    goto :parse
    :case_9
    const-string v0, "126.997155"
    goto :parse
    :case_10
    const-string v0, "126.980280"
    goto :parse
    :case_11
    const-string v0, "126.982125"
    goto :parse
    :case_12
    const-string v0, "126.959372"
    goto :parse
    :case_13
    const-string v0, "126.997949"
    goto :parse
    :case_14
    const-string v0, "126.996035"
    goto :parse
    :case_15
    const-string v0, "126.963504"
    goto :parse
    :case_16
    const-string v0, "126.958140"
    goto :parse
    :case_17
    const-string v0, "126.997207"
    goto :parse
    :case_18
    const-string v0, "126.984033"
    goto :parse
    :case_19
    const-string v0, "126.999494"
    goto :parse
    :parse
    invoke-static {v0}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D
    move-result-wide v2
    return-wide v2
    :pd
    .packed-switch 0x0
        :case_0
        :case_1
        :case_2
        :case_3
        :case_4
        :case_5
        :case_6
        :case_7
        :case_8
        :case_9
        :case_10
        :case_11
        :case_12
        :case_13
        :case_14
        :case_15
        :case_16
        :case_17
        :case_18
        :case_19
    .end packed-switch
.end method

.method public static numKR(I)Ljava/lang/String;
    .registers 2
    .param p0, "i"

    packed-switch p0, :pd
    :case_0
    const-string v0, "45005"
    return-object v0
    :case_1
    const-string v0, "45008"
    return-object v0
    :case_2
    const-string v0, "45006"
    return-object v0
    const-string v0, ""
    return-object v0
    :pd
    .packed-switch 0x0
        :case_0
        :case_1
        :case_2
    .end packed-switch
.end method

.method public static namKR(I)Ljava/lang/String;
    .registers 2
    .param p0, "i"

    packed-switch p0, :pd
    :case_0
    const-string v0, "SKTelecom"
    return-object v0
    :case_1
    const-string v0, "KT"
    return-object v0
    :case_2
    const-string v0, "LG U+"
    return-object v0
    const-string v0, ""
    return-object v0
    :pd
    .packed-switch 0x0
        :case_0
        :case_1
        :case_2
    .end packed-switch
.end method

.method public static latJP(I)D
    .registers 4
    .param p0, "i"

    packed-switch p0, :pd
    :case_0
    const-string v0, "35.694430"
    goto :parse
    :case_1
    const-string v0, "35.691739"
    goto :parse
    :case_2
    const-string v0, "35.652439"
    goto :parse
    :case_3
    const-string v0, "35.667809"
    goto :parse
    :case_4
    const-string v0, "35.691312"
    goto :parse
    :case_5
    const-string v0, "35.691737"
    goto :parse
    :case_6
    const-string v0, "35.690569"
    goto :parse
    :case_7
    const-string v0, "35.694808"
    goto :parse
    :case_8
    const-string v0, "35.662322"
    goto :parse
    :case_9
    const-string v0, "35.674215"
    goto :parse
    :case_10
    const-string v0, "35.690967"
    goto :parse
    :case_11
    const-string v0, "35.652383"
    goto :parse
    :case_12
    const-string v0, "35.667613"
    goto :parse
    :case_13
    const-string v0, "35.699544"
    goto :parse
    :case_14
    const-string v0, "35.683274"
    goto :parse
    :case_15
    const-string v0, "35.700257"
    goto :parse
    :case_16
    const-string v0, "35.698162"
    goto :parse
    :case_17
    const-string v0, "35.699720"
    goto :parse
    :case_18
    const-string v0, "35.699327"
    goto :parse
    :case_19
    const-string v0, "35.656620"
    goto :parse
    :parse
    invoke-static {v0}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D
    move-result-wide v2
    return-wide v2
    :pd
    .packed-switch 0x0
        :case_0
        :case_1
        :case_2
        :case_3
        :case_4
        :case_5
        :case_6
        :case_7
        :case_8
        :case_9
        :case_10
        :case_11
        :case_12
        :case_13
        :case_14
        :case_15
        :case_16
        :case_17
        :case_18
        :case_19
    .end packed-switch
.end method

.method public static lonJP(I)D
    .registers 4
    .param p0, "i"

    packed-switch p0, :pd
    :case_0
    const-string v0, "139.674110"
    goto :parse
    :case_1
    const-string v0, "139.669371"
    goto :parse
    :case_2
    const-string v0, "139.662128"
    goto :parse
    :case_3
    const-string v0, "139.671841"
    goto :parse
    :case_4
    const-string v0, "139.668503"
    goto :parse
    :case_5
    const-string v0, "139.638640"
    goto :parse
    :case_6
    const-string v0, "139.630705"
    goto :parse
    :case_7
    const-string v0, "139.668230"
    goto :parse
    :case_8
    const-string v0, "139.666129"
    goto :parse
    :case_9
    const-string v0, "139.640560"
    goto :parse
    :case_10
    const-string v0, "139.636680"
    goto :parse
    :case_11
    const-string v0, "139.634956"
    goto :parse
    :case_12
    const-string v0, "139.668518"
    goto :parse
    :case_13
    const-string v0, "139.639256"
    goto :parse
    :case_14
    const-string v0, "139.645284"
    goto :parse
    :case_15
    const-string v0, "139.652111"
    goto :parse
    :case_16
    const-string v0, "139.631067"
    goto :parse
    :case_17
    const-string v0, "139.634228"
    goto :parse
    :case_18
    const-string v0, "139.638573"
    goto :parse
    :case_19
    const-string v0, "139.647028"
    goto :parse
    :parse
    invoke-static {v0}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D
    move-result-wide v2
    return-wide v2
    :pd
    .packed-switch 0x0
        :case_0
        :case_1
        :case_2
        :case_3
        :case_4
        :case_5
        :case_6
        :case_7
        :case_8
        :case_9
        :case_10
        :case_11
        :case_12
        :case_13
        :case_14
        :case_15
        :case_16
        :case_17
        :case_18
        :case_19
    .end packed-switch
.end method

.method public static numJP(I)Ljava/lang/String;
    .registers 2
    .param p0, "i"

    packed-switch p0, :pd
    :case_0
    const-string v0, "44010"
    return-object v0
    :case_1
    const-string v0, "44050"
    return-object v0
    :case_2
    const-string v0, "44020"
    return-object v0
    const-string v0, ""
    return-object v0
    :pd
    .packed-switch 0x0
        :case_0
        :case_1
        :case_2
    .end packed-switch
.end method

.method public static namJP(I)Ljava/lang/String;
    .registers 2
    .param p0, "i"

    packed-switch p0, :pd
    :case_0
    const-string v0, "NTT DOCOMO"
    return-object v0
    :case_1
    const-string v0, "au"
    return-object v0
    :case_2
    const-string v0, "SoftBank"
    return-object v0
    const-string v0, ""
    return-object v0
    :pd
    .packed-switch 0x0
        :case_0
        :case_1
        :case_2
    .end packed-switch
.end method

.method public static latIT(I)D
    .registers 4
    .param p0, "i"

    packed-switch p0, :pd
    :case_0
    const-string v0, "41.914227"
    goto :parse
    :case_1
    const-string v0, "41.908110"
    goto :parse
    :case_2
    const-string v0, "41.897060"
    goto :parse
    :case_3
    const-string v0, "41.890536"
    goto :parse
    :case_4
    const-string v0, "41.877885"
    goto :parse
    :case_5
    const-string v0, "41.904723"
    goto :parse
    :case_6
    const-string v0, "41.914898"
    goto :parse
    :case_7
    const-string v0, "41.896011"
    goto :parse
    :case_8
    const-string v0, "41.911012"
    goto :parse
    :case_9
    const-string v0, "41.893496"
    goto :parse
    :case_10
    const-string v0, "41.913788"
    goto :parse
    :case_11
    const-string v0, "41.893264"
    goto :parse
    :case_12
    const-string v0, "41.897920"
    goto :parse
    :case_13
    const-string v0, "41.884164"
    goto :parse
    :case_14
    const-string v0, "41.924818"
    goto :parse
    :case_15
    const-string v0, "41.922940"
    goto :parse
    :case_16
    const-string v0, "41.892847"
    goto :parse
    :case_17
    const-string v0, "41.877820"
    goto :parse
    :case_18
    const-string v0, "41.899294"
    goto :parse
    :case_19
    const-string v0, "41.910535"
    goto :parse
    :parse
    invoke-static {v0}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D
    move-result-wide v2
    return-wide v2
    :pd
    .packed-switch 0x0
        :case_0
        :case_1
        :case_2
        :case_3
        :case_4
        :case_5
        :case_6
        :case_7
        :case_8
        :case_9
        :case_10
        :case_11
        :case_12
        :case_13
        :case_14
        :case_15
        :case_16
        :case_17
        :case_18
        :case_19
    .end packed-switch
.end method

.method public static lonIT(I)D
    .registers 4
    .param p0, "i"

    packed-switch p0, :pd
    :case_0
    const-string v0, "12.487084"
    goto :parse
    :case_1
    const-string v0, "12.496971"
    goto :parse
    :case_2
    const-string v0, "12.500229"
    goto :parse
    :case_3
    const-string v0, "12.506839"
    goto :parse
    :case_4
    const-string v0, "12.517679"
    goto :parse
    :case_5
    const-string v0, "12.507371"
    goto :parse
    :case_6
    const-string v0, "12.504931"
    goto :parse
    :case_7
    const-string v0, "12.474899"
    goto :parse
    :case_8
    const-string v0, "12.487910"
    goto :parse
    :case_9
    const-string v0, "12.513801"
    goto :parse
    :case_10
    const-string v0, "12.486416"
    goto :parse
    :case_11
    const-string v0, "12.491820"
    goto :parse
    :case_12
    const-string v0, "12.486183"
    goto :parse
    :case_13
    const-string v0, "12.492422"
    goto :parse
    :case_14
    const-string v0, "12.505266"
    goto :parse
    :case_15
    const-string v0, "12.502176"
    goto :parse
    :case_16
    const-string v0, "12.498797"
    goto :parse
    :case_17
    const-string v0, "12.485746"
    goto :parse
    :case_18
    const-string v0, "12.500399"
    goto :parse
    :case_19
    const-string v0, "12.494649"
    goto :parse
    :parse
    invoke-static {v0}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D
    move-result-wide v2
    return-wide v2
    :pd
    .packed-switch 0x0
        :case_0
        :case_1
        :case_2
        :case_3
        :case_4
        :case_5
        :case_6
        :case_7
        :case_8
        :case_9
        :case_10
        :case_11
        :case_12
        :case_13
        :case_14
        :case_15
        :case_16
        :case_17
        :case_18
        :case_19
    .end packed-switch
.end method

.method public static numIT(I)Ljava/lang/String;
    .registers 2
    .param p0, "i"

    packed-switch p0, :pd
    :case_0
    const-string v0, "22201"
    return-object v0
    :case_1
    const-string v0, "22210"
    return-object v0
    :case_2
    const-string v0, "22288"
    return-object v0
    const-string v0, ""
    return-object v0
    :pd
    .packed-switch 0x0
        :case_0
        :case_1
        :case_2
    .end packed-switch
.end method

.method public static namIT(I)Ljava/lang/String;
    .registers 2
    .param p0, "i"

    packed-switch p0, :pd
    :case_0
    const-string v0, "TIM"
    return-object v0
    :case_1
    const-string v0, "Vodafone IT"
    return-object v0
    :case_2
    const-string v0, "WindTre"
    return-object v0
    const-string v0, ""
    return-object v0
    :pd
    .packed-switch 0x0
        :case_0
        :case_1
        :case_2
    .end packed-switch
.end method

.method public static latNL(I)D
    .registers 4
    .param p0, "i"

    packed-switch p0, :pd
    :case_0
    const-string v0, "52.364708"
    goto :parse
    :case_1
    const-string v0, "52.366259"
    goto :parse
    :case_2
    const-string v0, "52.382401"
    goto :parse
    :case_3
    const-string v0, "52.346840"
    goto :parse
    :case_4
    const-string v0, "52.374247"
    goto :parse
    :case_5
    const-string v0, "52.383521"
    goto :parse
    :case_6
    const-string v0, "52.376240"
    goto :parse
    :case_7
    const-string v0, "52.352556"
    goto :parse
    :case_8
    const-string v0, "52.354842"
    goto :parse
    :case_9
    const-string v0, "52.385087"
    goto :parse
    :case_10
    const-string v0, "52.363322"
    goto :parse
    :case_11
    const-string v0, "52.352322"
    goto :parse
    :case_12
    const-string v0, "52.367319"
    goto :parse
    :case_13
    const-string v0, "52.375403"
    goto :parse
    :case_14
    const-string v0, "52.380148"
    goto :parse
    :case_15
    const-string v0, "52.347929"
    goto :parse
    :case_16
    const-string v0, "52.351394"
    goto :parse
    :case_17
    const-string v0, "52.368498"
    goto :parse
    :case_18
    const-string v0, "52.355060"
    goto :parse
    :case_19
    const-string v0, "52.365423"
    goto :parse
    :parse
    invoke-static {v0}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D
    move-result-wide v2
    return-wide v2
    :pd
    .packed-switch 0x0
        :case_0
        :case_1
        :case_2
        :case_3
        :case_4
        :case_5
        :case_6
        :case_7
        :case_8
        :case_9
        :case_10
        :case_11
        :case_12
        :case_13
        :case_14
        :case_15
        :case_16
        :case_17
        :case_18
        :case_19
    .end packed-switch
.end method

.method public static lonNL(I)D
    .registers 4
    .param p0, "i"

    packed-switch p0, :pd
    :case_0
    const-string v0, "4.889785"
    goto :parse
    :case_1
    const-string v0, "4.924159"
    goto :parse
    :case_2
    const-string v0, "4.887585"
    goto :parse
    :case_3
    const-string v0, "4.904873"
    goto :parse
    :case_4
    const-string v0, "4.895859"
    goto :parse
    :case_5
    const-string v0, "4.916657"
    goto :parse
    :case_6
    const-string v0, "4.890332"
    goto :parse
    :case_7
    const-string v0, "4.880321"
    goto :parse
    :case_8
    const-string v0, "4.902857"
    goto :parse
    :case_9
    const-string v0, "4.882741"
    goto :parse
    :case_10
    const-string v0, "4.910588"
    goto :parse
    :case_11
    const-string v0, "4.913918"
    goto :parse
    :case_12
    const-string v0, "4.891299"
    goto :parse
    :case_13
    const-string v0, "4.879377"
    goto :parse
    :case_14
    const-string v0, "4.917602"
    goto :parse
    :case_15
    const-string v0, "4.900357"
    goto :parse
    :case_16
    const-string v0, "4.926998"
    goto :parse
    :case_17
    const-string v0, "4.881611"
    goto :parse
    :case_18
    const-string v0, "4.921517"
    goto :parse
    :case_19
    const-string v0, "4.919171"
    goto :parse
    :parse
    invoke-static {v0}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D
    move-result-wide v2
    return-wide v2
    :pd
    .packed-switch 0x0
        :case_0
        :case_1
        :case_2
        :case_3
        :case_4
        :case_5
        :case_6
        :case_7
        :case_8
        :case_9
        :case_10
        :case_11
        :case_12
        :case_13
        :case_14
        :case_15
        :case_16
        :case_17
        :case_18
        :case_19
    .end packed-switch
.end method

.method public static numNL(I)Ljava/lang/String;
    .registers 2
    .param p0, "i"

    packed-switch p0, :pd
    :case_0
    const-string v0, "20408"
    return-object v0
    :case_1
    const-string v0, "20404"
    return-object v0
    :case_2
    const-string v0, "20402"
    return-object v0
    const-string v0, ""
    return-object v0
    :pd
    .packed-switch 0x0
        :case_0
        :case_1
        :case_2
    .end packed-switch
.end method

.method public static namNL(I)Ljava/lang/String;
    .registers 2
    .param p0, "i"

    packed-switch p0, :pd
    :case_0
    const-string v0, "KPN"
    return-object v0
    :case_1
    const-string v0, "Vodafone NL"
    return-object v0
    :case_2
    const-string v0, "T-Mobile NL"
    return-object v0
    const-string v0, ""
    return-object v0
    :pd
    .packed-switch 0x0
        :case_0
        :case_1
        :case_2
    .end packed-switch
.end method

.method private static getLatImpl()D
    .registers 6
    const/16 v0, 0x14
    invoke-static {v0}, Landroid/location/Spoof;->getIdx(I)I
    move-result v0
    invoke-static {}, Landroid/location/Spoof;->getCountry()Ljava/lang/String;
    move-result-object v1
    const-string v2, "US"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :n0
    invoke-static {v0}, Landroid/location/Spoof;->latUS(I)D
    move-result-wide v4
    return-wide v4
    :n0
    const-string v2, "DE"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :n1
    invoke-static {v0}, Landroid/location/Spoof;->latDE(I)D
    move-result-wide v4
    return-wide v4
    :n1
    const-string v2, "GB"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :n2
    invoke-static {v0}, Landroid/location/Spoof;->latGB(I)D
    move-result-wide v4
    return-wide v4
    :n2
    const-string v2, "CA"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :n3
    invoke-static {v0}, Landroid/location/Spoof;->latCA(I)D
    move-result-wide v4
    return-wide v4
    :n3
    const-string v2, "AT"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :n4
    invoke-static {v0}, Landroid/location/Spoof;->latAT(I)D
    move-result-wide v4
    return-wide v4
    :n4
    const-string v2, "AU"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :n5
    invoke-static {v0}, Landroid/location/Spoof;->latAU(I)D
    move-result-wide v4
    return-wide v4
    :n5
    const-string v2, "CH"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :n6
    invoke-static {v0}, Landroid/location/Spoof;->latCH(I)D
    move-result-wide v4
    return-wide v4
    :n6
    const-string v2, "KR"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :n7
    invoke-static {v0}, Landroid/location/Spoof;->latKR(I)D
    move-result-wide v4
    return-wide v4
    :n7
    const-string v2, "JP"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :n8
    invoke-static {v0}, Landroid/location/Spoof;->latJP(I)D
    move-result-wide v4
    return-wide v4
    :n8
    const-string v2, "IT"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :n9
    invoke-static {v0}, Landroid/location/Spoof;->latIT(I)D
    move-result-wide v4
    return-wide v4
    :n9
    invoke-static {v0}, Landroid/location/Spoof;->latNL(I)D
    move-result-wide v4
    return-wide v4
.end method

.method private static getLonImpl()D
    .registers 6
    const/16 v0, 0x14
    invoke-static {v0}, Landroid/location/Spoof;->getIdx(I)I
    move-result v0
    invoke-static {}, Landroid/location/Spoof;->getCountry()Ljava/lang/String;
    move-result-object v1
    const-string v2, "US"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :n0
    invoke-static {v0}, Landroid/location/Spoof;->lonUS(I)D
    move-result-wide v4
    return-wide v4
    :n0
    const-string v2, "DE"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :n1
    invoke-static {v0}, Landroid/location/Spoof;->lonDE(I)D
    move-result-wide v4
    return-wide v4
    :n1
    const-string v2, "GB"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :n2
    invoke-static {v0}, Landroid/location/Spoof;->lonGB(I)D
    move-result-wide v4
    return-wide v4
    :n2
    const-string v2, "CA"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :n3
    invoke-static {v0}, Landroid/location/Spoof;->lonCA(I)D
    move-result-wide v4
    return-wide v4
    :n3
    const-string v2, "AT"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :n4
    invoke-static {v0}, Landroid/location/Spoof;->lonAT(I)D
    move-result-wide v4
    return-wide v4
    :n4
    const-string v2, "AU"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :n5
    invoke-static {v0}, Landroid/location/Spoof;->lonAU(I)D
    move-result-wide v4
    return-wide v4
    :n5
    const-string v2, "CH"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :n6
    invoke-static {v0}, Landroid/location/Spoof;->lonCH(I)D
    move-result-wide v4
    return-wide v4
    :n6
    const-string v2, "KR"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :n7
    invoke-static {v0}, Landroid/location/Spoof;->lonKR(I)D
    move-result-wide v4
    return-wide v4
    :n7
    const-string v2, "JP"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :n8
    invoke-static {v0}, Landroid/location/Spoof;->lonJP(I)D
    move-result-wide v4
    return-wide v4
    :n8
    const-string v2, "IT"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :n9
    invoke-static {v0}, Landroid/location/Spoof;->lonIT(I)D
    move-result-wide v4
    return-wide v4
    :n9
    invoke-static {v0}, Landroid/location/Spoof;->lonNL(I)D
    move-result-wide v4
    return-wide v4
.end method

.method private static getOpNumericImpl()Ljava/lang/String;
    .registers 6
    const/16 v0, 0x3
    invoke-static {v0}, Landroid/location/Spoof;->getIdx(I)I
    move-result v0
    invoke-static {}, Landroid/location/Spoof;->getCountry()Ljava/lang/String;
    move-result-object v1
    const-string v2, "US"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :n0
    invoke-static {v0}, Landroid/location/Spoof;->numUS(I)Ljava/lang/String;
    move-result-object v3
    return-object v3
    :n0
    const-string v2, "DE"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :n1
    invoke-static {v0}, Landroid/location/Spoof;->numDE(I)Ljava/lang/String;
    move-result-object v3
    return-object v3
    :n1
    const-string v2, "GB"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :n2
    invoke-static {v0}, Landroid/location/Spoof;->numGB(I)Ljava/lang/String;
    move-result-object v3
    return-object v3
    :n2
    const-string v2, "CA"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :n3
    invoke-static {v0}, Landroid/location/Spoof;->numCA(I)Ljava/lang/String;
    move-result-object v3
    return-object v3
    :n3
    const-string v2, "AT"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :n4
    invoke-static {v0}, Landroid/location/Spoof;->numAT(I)Ljava/lang/String;
    move-result-object v3
    return-object v3
    :n4
    const-string v2, "AU"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :n5
    invoke-static {v0}, Landroid/location/Spoof;->numAU(I)Ljava/lang/String;
    move-result-object v3
    return-object v3
    :n5
    const-string v2, "CH"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :n6
    invoke-static {v0}, Landroid/location/Spoof;->numCH(I)Ljava/lang/String;
    move-result-object v3
    return-object v3
    :n6
    const-string v2, "KR"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :n7
    invoke-static {v0}, Landroid/location/Spoof;->numKR(I)Ljava/lang/String;
    move-result-object v3
    return-object v3
    :n7
    const-string v2, "JP"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :n8
    invoke-static {v0}, Landroid/location/Spoof;->numJP(I)Ljava/lang/String;
    move-result-object v3
    return-object v3
    :n8
    const-string v2, "IT"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :n9
    invoke-static {v0}, Landroid/location/Spoof;->numIT(I)Ljava/lang/String;
    move-result-object v3
    return-object v3
    :n9
    invoke-static {v0}, Landroid/location/Spoof;->numNL(I)Ljava/lang/String;
    move-result-object v3
    return-object v3
.end method

.method private static getOpNameImpl()Ljava/lang/String;
    .registers 6
    const/16 v0, 0x3
    invoke-static {v0}, Landroid/location/Spoof;->getIdx(I)I
    move-result v0
    invoke-static {}, Landroid/location/Spoof;->getCountry()Ljava/lang/String;
    move-result-object v1
    const-string v2, "US"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :n0
    invoke-static {v0}, Landroid/location/Spoof;->namUS(I)Ljava/lang/String;
    move-result-object v3
    return-object v3
    :n0
    const-string v2, "DE"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :n1
    invoke-static {v0}, Landroid/location/Spoof;->namDE(I)Ljava/lang/String;
    move-result-object v3
    return-object v3
    :n1
    const-string v2, "GB"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :n2
    invoke-static {v0}, Landroid/location/Spoof;->namGB(I)Ljava/lang/String;
    move-result-object v3
    return-object v3
    :n2
    const-string v2, "CA"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :n3
    invoke-static {v0}, Landroid/location/Spoof;->namCA(I)Ljava/lang/String;
    move-result-object v3
    return-object v3
    :n3
    const-string v2, "AT"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :n4
    invoke-static {v0}, Landroid/location/Spoof;->namAT(I)Ljava/lang/String;
    move-result-object v3
    return-object v3
    :n4
    const-string v2, "AU"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :n5
    invoke-static {v0}, Landroid/location/Spoof;->namAU(I)Ljava/lang/String;
    move-result-object v3
    return-object v3
    :n5
    const-string v2, "CH"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :n6
    invoke-static {v0}, Landroid/location/Spoof;->namCH(I)Ljava/lang/String;
    move-result-object v3
    return-object v3
    :n6
    const-string v2, "KR"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :n7
    invoke-static {v0}, Landroid/location/Spoof;->namKR(I)Ljava/lang/String;
    move-result-object v3
    return-object v3
    :n7
    const-string v2, "JP"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :n8
    invoke-static {v0}, Landroid/location/Spoof;->namJP(I)Ljava/lang/String;
    move-result-object v3
    return-object v3
    :n8
    const-string v2, "IT"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :n9
    invoke-static {v0}, Landroid/location/Spoof;->namIT(I)Ljava/lang/String;
    move-result-object v3
    return-object v3
    :n9
    invoke-static {v0}, Landroid/location/Spoof;->namNL(I)Ljava/lang/String;
    move-result-object v3
    return-object v3
.end method

.method public static getMcc()Ljava/lang/String;
    .registers 4
    invoke-static {}, Landroid/location/Spoof;->getOpNumeric()Ljava/lang/String;
    move-result-object v0
    const/4 v1, 0x0
    const/4 v2, 0x3
    invoke-virtual {v0, v1, v2}, Ljava/lang/String;->substring(II)Ljava/lang/String;
    move-result-object v0
    return-object v0
.end method

.method public static getMnc()Ljava/lang/String;
    .registers 3
    invoke-static {}, Landroid/location/Spoof;->getOpNumeric()Ljava/lang/String;
    move-result-object v0
    const/4 v1, 0x3
    invoke-virtual {v0, v1}, Ljava/lang/String;->substring(I)Ljava/lang/String;
    move-result-object v0
    return-object v0
.end method


# ===== Cached wrappers (TTL: country 60 min, others 20 min) =====

.method public static getCountry()Ljava/lang/String;
    .registers 7
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J
    move-result-wide v0
    sget-object v2, Landroid/location/Spoof;->sCountry:Ljava/lang/String;
    if-eqz v2, :miss
    sget-wide v3, Landroid/location/Spoof;->sCountryTs:J
    sub-long v5, v0, v3
    const-wide/32 v3, 0x36ee80
    cmp-long v3, v5, v3
    if-gez v3, :miss
    return-object v2
    :miss
    invoke-static {}, Landroid/location/Spoof;->getCountryImpl()Ljava/lang/String;
    move-result-object v2
    sput-object v2, Landroid/location/Spoof;->sCountry:Ljava/lang/String;
    sput-wide v0, Landroid/location/Spoof;->sCountryTs:J
    return-object v2
.end method

.method public static getLat()D
    .registers 9
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J
    move-result-wide v0
    sget-boolean v2, Landroid/location/Spoof;->sLatValid:Z
    if-eqz v2, :miss
    sget-wide v3, Landroid/location/Spoof;->sLatTs:J
    sub-long v5, v0, v3
    const-wide/32 v3, 0x124f80
    cmp-long v3, v5, v3
    if-gez v3, :miss
    sget-wide v7, Landroid/location/Spoof;->sLat:D
    return-wide v7
    :miss
    invoke-static {}, Landroid/location/Spoof;->getLatImpl()D
    move-result-wide v7
    sput-wide v7, Landroid/location/Spoof;->sLat:D
    sput-wide v0, Landroid/location/Spoof;->sLatTs:J
    const/4 v2, 0x1
    sput-boolean v2, Landroid/location/Spoof;->sLatValid:Z
    return-wide v7
.end method

.method public static getLon()D
    .registers 9
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J
    move-result-wide v0
    sget-boolean v2, Landroid/location/Spoof;->sLonValid:Z
    if-eqz v2, :miss
    sget-wide v3, Landroid/location/Spoof;->sLonTs:J
    sub-long v5, v0, v3
    const-wide/32 v3, 0x124f80
    cmp-long v3, v5, v3
    if-gez v3, :miss
    sget-wide v7, Landroid/location/Spoof;->sLon:D
    return-wide v7
    :miss
    invoke-static {}, Landroid/location/Spoof;->getLonImpl()D
    move-result-wide v7
    sput-wide v7, Landroid/location/Spoof;->sLon:D
    sput-wide v0, Landroid/location/Spoof;->sLonTs:J
    const/4 v2, 0x1
    sput-boolean v2, Landroid/location/Spoof;->sLonValid:Z
    return-wide v7
.end method

.method public static getOpNumeric()Ljava/lang/String;
    .registers 7
    const-string v0, "devicespoof.operator.numeric"
    invoke-static {v0}, Landroid/os/BuildSpoof;->get(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    if-eqz v2, :auto
    invoke-virtual {v2}, Ljava/lang/String;->isEmpty()Z
    move-result v3
    if-nez v3, :auto
    return-object v2
    :auto
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J
    move-result-wide v0
    sget-object v2, Landroid/location/Spoof;->sOpNum:Ljava/lang/String;
    if-eqz v2, :miss
    sget-wide v3, Landroid/location/Spoof;->sOpNumTs:J
    sub-long v5, v0, v3
    const-wide/32 v3, 0x124f80
    cmp-long v3, v5, v3
    if-gez v3, :miss
    return-object v2
    :miss
    invoke-static {}, Landroid/location/Spoof;->getOpNumericImpl()Ljava/lang/String;
    move-result-object v2
    sput-object v2, Landroid/location/Spoof;->sOpNum:Ljava/lang/String;
    sput-wide v0, Landroid/location/Spoof;->sOpNumTs:J
    return-object v2
.end method

.method public static getOpName()Ljava/lang/String;
    .registers 7
    const-string v0, "devicespoof.operator.name"
    invoke-static {v0}, Landroid/os/BuildSpoof;->get(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    if-eqz v2, :auto
    invoke-virtual {v2}, Ljava/lang/String;->isEmpty()Z
    move-result v3
    if-nez v3, :auto
    return-object v2
    :auto
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J
    move-result-wide v0
    sget-object v2, Landroid/location/Spoof;->sOpName:Ljava/lang/String;
    if-eqz v2, :miss
    sget-wide v3, Landroid/location/Spoof;->sOpNameTs:J
    sub-long v5, v0, v3
    const-wide/32 v3, 0x124f80
    cmp-long v3, v5, v3
    if-gez v3, :miss
    return-object v2
    :miss
    invoke-static {}, Landroid/location/Spoof;->getOpNameImpl()Ljava/lang/String;
    move-result-object v2
    sput-object v2, Landroid/location/Spoof;->sOpName:Ljava/lang/String;
    sput-wide v0, Landroid/location/Spoof;->sOpNameTs:J
    return-object v2
.end method
