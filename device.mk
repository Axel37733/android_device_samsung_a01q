DEVICE_PATH := device/samsung/a01q

# ============================================================
# BASE PRODUCT
# ro.product.first_api_level=29 → lanzado con Android 10 (Q)
# ============================================================
$(call inherit-product, $(SRC_TARGET_DIR)/product/product_launched_with_q.mk)

# Dynamic Partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# NO A/B
AB_OTA_UPDATER := false

# Shipping API level: Android 10 = 29
PRODUCT_SHIPPING_API_LEVEL := 29

# VNDK — vendor blobs son de Android 12 (VNDK 31)
# Sistema corre Android 13, vendor se queda en 31
PRODUCT_TARGET_VNDK_VERSION  := 31
PRODUCT_EXTRA_VNDK_VERSIONS  := 31

# APEX
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(DEVICE_PATH) \
    hardware/qcom-caf/msm8937

# ============================================================
# OVERLAYS
# ============================================================
DEVICE_PACKAGE_OVERLAYS += $(DEVICE_PATH)/overlay
ifneq ($(findstring lineage, $(TARGET_PRODUCT)),)
DEVICE_PACKAGE_OVERLAYS += $(DEVICE_PATH)/overlay-lineage
endif
PRODUCT_ENFORCE_RRO_TARGETS := *

# ============================================================
# AAPT — xhdpi (320dpi), región Latin America / Argentina
# ============================================================
PRODUCT_AAPT_CONFIG      := normal
PRODUCT_AAPT_PREF_CONFIG := xhdpi

# ============================================================
# AUDIO HAL
# Vendor blobs implementan HIDL @6.0 (Android 12)
# LOS 20 usa @6.0-impl en modo passthrough para compatibilidad
# vendor.audio.feature.* confirmados por getprop real
# ============================================================
PRODUCT_PACKAGES += \
    android.hardware.audio@6.0-impl:32 \
    android.hardware.audio.effect@6.0-impl:32 \
    android.hardware.soundtrigger@2.3-impl \
    android.hardware.audio.service \
    audio.a2dp.default \
    audio.primary.msm8937 \
    audio.r_submix.default \
    audio.usb.default \
    libaudio-resampler \
    libqcomvisualizer \
    libqcomvoiceprocessing \
    libqcompostprocbundle \
    libvolumelistener

PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/audio/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    $(DEVICE_PATH)/audio/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml \
    frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml

# FM Radio — vendor.audio.feature.fm.enable=true
PRODUCT_PACKAGES += \
    FM2 \
    libqcomfm_jni \
    qcom.fmradio

# ============================================================
# BLUETOOTH HAL
# Android 13 → @1.1
# BT SoC: Pronto (wcnss) — wipower=false, split a2dp=false
# ============================================================
PRODUCT_PACKAGES += \
    android.hardware.bluetooth@1.1-impl \
    android.hardware.bluetooth@1.1-service.msm8937

# ============================================================
# CAMERA HAL
# HIDL @3.4 — sin NFC, sin fingerprint (A01 budget device)
# ============================================================
PRODUCT_PACKAGES += \
    android.hardware.camera.provider@2.4-impl \
    android.hardware.camera.provider@2.4-service \
    camera.msm8937 \
    libxml2

# ============================================================
# DISPLAY HAL
# Adreno 505 — HWC2, gralloc1, ION
# ============================================================
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.mapper@2.0-impl-2.1 \
    android.hardware.graphics.composer@2.1-service \
    android.hardware.memtrack@1.0-impl \
    android.hardware.memtrack@1.0-service \
    libdisplayconfig \
    libqdutils \
    libqdMetaData \
    gralloc.msm8937 \
    hwcomposer.msm8937 \
    memtrack.msm8937 \
    liboverlay

# ============================================================
# GNSS / GPS
# init.svc.gnss_service=running → GPS activo en stock
# ============================================================
PRODUCT_PACKAGES += \
    android.hardware.gnss@2.1-impl-qti \
    android.hardware.gnss@2.1-service-qti

PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/configs/gps/gps.conf:$(TARGET_COPY_OUT_VENDOR)/etc/gps.conf \
    $(DEVICE_PATH)/configs/gps/flp.conf:$(TARGET_COPY_OUT_VENDOR)/etc/flp.conf \
    $(DEVICE_PATH)/configs/gps/izat.conf:$(TARGET_COPY_OUT_VENDOR)/etc/izat.conf \
    $(DEVICE_PATH)/configs/gps/lowi.conf:$(TARGET_COPY_OUT_VENDOR)/etc/lowi.conf \
    $(DEVICE_PATH)/configs/gps/sap.conf:$(TARGET_COPY_OUT_VENDOR)/etc/sap.conf \
    $(DEVICE_PATH)/configs/gps/xtwifi.conf:$(TARGET_COPY_OUT_VENDOR)/etc/xtwifi.conf

# ============================================================
# HEALTH HAL — Android 13 requiere @2.1
# ============================================================
PRODUCT_PACKAGES += \
    android.hardware.health@2.1-impl \
    android.hardware.health@2.1-impl.recovery \
    android.hardware.health@2.1-service

# ============================================================
# KEYMASTER / GATEKEEPER HAL
# ============================================================
PRODUCT_PACKAGES += \
    android.hardware.keymaster@4.1-impl \
    android.hardware.keymaster@4.1-service \
    android.hardware.gatekeeper@1.0-impl \
    android.hardware.gatekeeper@1.0-service

# ============================================================
# POWER HAL — Android 13 usa AIDL power service
# pero msm8937 vendor solo soporta HIDL
# ============================================================
PRODUCT_PACKAGES += \
    android.hardware.power@1.3-impl \
    android.hardware.power-service-qti

# ============================================================
# SENSORS HAL
# ============================================================
PRODUCT_PACKAGES += \
    android.hardware.sensors@1.0-impl \
    android.hardware.sensors@1.0-service \
    sensors.msm8937

# ============================================================
# THERMAL HAL
# ============================================================
PRODUCT_PACKAGES += \
    android.hardware.thermal@2.0-service.qti

# ============================================================
# USB HAL
# sys.usb.config=mtp,adb, sys.usb.configfs=1
# ============================================================
PRODUCT_PACKAGES += \
    android.hardware.usb@1.3-service.msm8937

# ============================================================
# VIBRATOR HAL
# ============================================================
PRODUCT_PACKAGES += \
    android.hardware.vibrator@1.3-impl \
    android.hardware.vibrator@1.3-service

# ============================================================
# WIFI HAL
# hardware: qcwcn, wcnss (Pronto)
# ============================================================
PRODUCT_PACKAGES += \
    android.hardware.wifi@1.0-service \
    hostapd \
    libwifi-hal-qcom \
    wpa_supplicant \
    wpa_supplicant.conf

PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/wifi/WCNSS_qcom_cfg.ini:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/WCNSS_qcom_cfg.ini

# ============================================================
# PERMISOS DE HARDWARE
# Sin NFC, sin fingerprint, sin face unlock (budget device)
# ============================================================
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.low_latency.xml \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.full.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.full.xml \
    frameworks/native/data/etc/android.hardware.camera.raw.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.raw.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.telephony.ims.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.ims.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.sip.voip.xml \
    frameworks/native/data/etc/handheld_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/handheld_core_hardware.xml

# ============================================================
# FSTAB y SCRIPTS DE INIT
# ============================================================
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/rootdir/etc/fstab.qcom:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.qcom \
    $(DEVICE_PATH)/rootdir/etc/fstab.qcom:$(TARGET_COPY_OUT_RAMDISK)/fstab.qcom \
    $(DEVICE_PATH)/rootdir/etc/init.target.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.target.rc \
    $(DEVICE_PATH)/rootdir/etc/init.qcom.power.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.qcom.power.rc

# ============================================================
# RIL / RADIO — Single SIM (persist.radio.multisim.config=ss)
# ============================================================
PRODUCT_PACKAGES += \
    librmnetctl \
    libcnefeatureconfig

# ============================================================
# MEMORY — 2GB RAM
# Configuración para bajo consumo de RAM
# dalvik.vm.heapgrowthlimit=128m, heapsize=256m (del getprop)
# ============================================================
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.heapstartsize=8m \
    dalvik.vm.heapgrowthlimit=128m \
    dalvik.vm.heapsize=256m \
    dalvik.vm.heaptargetutilization=0.75 \
    dalvik.vm.heapminfree=512k \
    dalvik.vm.heapmaxfree=8m

# ============================================================
# ZRAM — confirmado por getprop: daily_quota=131072 (128MB)
# ============================================================
PRODUCT_PROPERTY_OVERRIDES += \
    ro.zram.mark_idle_delay_mins=60 \
    ro.zram.first_wb_delay_mins=1440 \
    ro.zram.periodic_wb_delay_hours=24

# ============================================================
# MISC PACKAGES
# ============================================================
PRODUCT_PACKAGES += \
    libavservices_minijail \
    libjni_latinime \
    libprotobuf-cpp-full \
    libprotobuf-cpp-lite \
    libtinyalsa

# Herramientas de vendor
PRODUCT_PACKAGES += \
    fs_config_files

# ============================================================
# SHIPPING API PROPERTIES
# ============================================================
PRODUCT_PROPERTY_OVERRIDES += \
    ro.product.first_api_level=29
