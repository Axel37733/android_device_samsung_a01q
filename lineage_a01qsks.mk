# Hereda configuración base de LineageOS 20 (Android 13)
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Hereda device.mk
$(call inherit-product, device/samsung/a01q/device.mk)

# Hereda vendor blobs (generado por extract-files.sh)
$(call inherit-product, vendor/samsung/a01q/a01q-vendor.mk)

# ============================================================
# IDENTIFICACIÓN DEL PRODUCTO
# ============================================================
PRODUCT_NAME         := lineage_a01qsks
PRODUCT_DEVICE       := a01q
PRODUCT_BRAND        := samsung
PRODUCT_MODEL        := SM-A015M
PRODUCT_MANUFACTURER := samsung

# GMS client ID
PRODUCT_GMS_CLIENTID_BASE := android-samsung-ss

# ============================================================
# BUILD OVERRIDES
# Mantener fingerprint de Samsung para compatibilidad con vendor blobs
# ro.build.fingerprint → usado para verificación de blobs
# ============================================================
PRODUCT_BUILD_PROP_OVERRIDES += \
    TARGET_DEVICE=a01q \
    PRODUCT_NAME=a01qub \
    PRIVATE_BUILD_DESC="a01qub-user 12 SP1A.210812.016 A015MUBS5CWI4 release-keys"

BUILD_FINGERPRINT := samsung/a01qub/a01q:12/SP1A.210812.016/A015MUBS5CWI4:user/release-keys
