DEVICE_PATH := device/samsung/a01q

# ============================================================
# ARQUITECTURA — Kernel 64-bit + Userspace 32-bit
#
# Kernel: ARM64 (confirmado por README_Kernel.txt: ARCH=arm64,
#         output: arch/arm64/boot/Image)
# Userspace: 32-bit (confirmado: ro.product.cpu.abi=armeabi-v7a,
#            ro.product.cpu.abilist=armeabi-v7a,armeabi)
#
# Esta configuración es intencional en Samsung para el SDM439:
# el kernel corre en 64-bit pero todo el userspace es 32-bit.
# TARGET_ARCH define el ABI del USERSPACE, no del kernel.
# ============================================================
TARGET_ARCH                := arm
TARGET_ARCH_VARIANT        := armv8-a
TARGET_CPU_ABI             := armeabi-v7a
TARGET_CPU_ABI2            := armeabi
TARGET_CPU_VARIANT         := cortex-a53
TARGET_CPU_VARIANT_RUNTIME := cortex-a53

# Binder 64-bit — el kernel es 64-bit aunque el userspace sea 32-bit
TARGET_USES_64_BIT_BINDER  := true

# ============================================================
# PLATFORM
# Confirmado: ro.board.platform=msm8937
# /proc/cpuinfo: "Qualcomm Technologies, Inc SDM439"
# ============================================================
TARGET_BOARD_PLATFORM    := msm8937
BOARD_USES_QCOM_HARDWARE := true

# ============================================================
# BOOTLOADER
# ro.product.board=QC_Reference_Phone
# ============================================================
TARGET_BOOTLOADER_BOARD_NAME := QC_Reference_Phone
TARGET_NO_BOOTLOADER         := true

# ============================================================
# KERNEL SOURCE
# Versión: 4.9.227 (confirmada en Makefile y uname del dispositivo)
# Source: SM-A015M_LATIN_12_Opensource / Kernel.tar.gz
#
# IMPORTANTE — confirmado por README_Kernel.txt:
#   - ARCH=arm64 → kernel 64-bit aunque el userspace sea 32-bit
#   - Output: arch/arm64/boot/Image (no zImage-dtb)
#   - Defconfig: samsung/a01q_eur_open_defconfig
#   - Toolchain: aarch64-linux-android-4.9 + clang 10.0
#   - Flag requerido: CONFIG_BUILD_ARM64_DT_OVERLAY=y
# ============================================================
BOARD_KERNEL_BASE        := 0x80000000
BOARD_KERNEL_PAGESIZE    := 2048
BOARD_RAMDISK_OFFSET     := 0x02000000
BOARD_KERNEL_TAGS_OFFSET := 0x01e00000
BOARD_KERNEL_OFFSET      := 0x00008000
BOARD_DTB_OFFSET         := 0x101f00000
BOARD_HEADER_SIZE        := 1660
BOARD_DTB_SIZE           := 859398
BOARD_KERNEL_IMAGE_NAME  := Image.gz-dtb
BOARD_BOOT_HEADER_VERSION := 2
BOARD_MKBOOTIMG_ARGS     += --header_version $(BOARD_BOOT_HEADER_VERSION)

BOARD_KERNEL_CMDLINE := console=null androidboot.console=ttyMSM0 androidboot.hardware=qcom user_debug=30 msm_rtb.filter=0x237 ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci lpm_levels.sleep_disabled=1 androidboot.usbconfigfs=true loop.max_part=7 printk.devkmsg=on androidboot.selinux=permissive

# Kernel - prebuilt (extraido del stock A015MUBS5CWI4)
TARGET_FORCE_PREBUILT_KERNEL := true
TARGET_PREBUILT_KERNEL       := $(DEVICE_PATH)/prebuilt/kernel
TARGET_PREBUILT_DTB          := $(DEVICE_PATH)/prebuilt/dtb.img
BOARD_PREBUILT_DTBIMAGE_DIR  := $(DEVICE_PATH)/prebuilt
BOARD_PREBUILT_DTBOIMAGE     := $(DEVICE_PATH)/prebuilt/dtbo.img

# Kernel source (para referencia, no se compila)
TARGET_KERNEL_SOURCE      := kernel/samsung/msm8937
TARGET_KERNEL_CONFIG      := samsung/a01q_eur_open_defconfig
TARGET_KERNEL_ARCH        := arm64
TARGET_KERNEL_HEADER_ARCH := arm64

# Device Tree Overlay
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_KERNEL_SEPARATED_DTBO  := true

# ============================================================
# PARTICIONES — tamaños exactos de /proc/partitions
# Cálculo: bloques × 1024 bytes
# ============================================================
BOARD_FLASH_BLOCK_SIZE := 131072

# boot     → mmcblk0p62 (65536 bloques)
BOARD_BOOTIMAGE_PARTITION_SIZE     := 67108864
# recovery → mmcblk0p61 (65536 bloques)
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 67108864
# dtbo     → mmcblk0p27 (8192 bloques)
BOARD_DTBOIMG_PARTITION_SIZE       := 8388608
# cache    → mmcblk0p75 (143360 bloques)
BOARD_CACHEIMAGE_PARTITION_SIZE    := 146800640
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE  := ext4
# metadata → mmcblk0p71 (32768 bloques)
BOARD_METADATAIMAGE_PARTITION_SIZE := 33554432
# persist  → mmcblk0p54 (32768 bloques)
BOARD_PERSISTIMAGE_PARTITION_SIZE  := 33554432

# ============================================================
# DYNAMIC PARTITIONS
# super → mmcblk0p72 (3857408 bloques × 1024 = 3,949,985,792)
# ============================================================
BOARD_SUPER_PARTITION_SIZE   := 3949985792
BOARD_SUPER_PARTITION_GROUPS := samsung_dynamic_partitions

# subparticiones de super: system, vendor, product, odm
# NOTA: prism (p73) y optics (p74) son particiones FÍSICAS — NO van aquí
BOARD_SAMSUNG_DYNAMIC_PARTITIONS_PARTITION_LIST := system vendor product odm
# super − 4MB overhead del metadata LP
BOARD_SAMSUNG_DYNAMIC_PARTITIONS_SIZE := 3945791488

BOARD_ROOT_EXTRA_FOLDERS := efs
BOARD_ROOT_EXTRA_SYMLINKS := \
        /vendor/dsp:/dsp \
        /vendor/firmware_mnt:/firmware \
        /mnt/vendor/persist:/persist \
        /mnt/vendor/efs:/efs

BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE  := ext4
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE  := ext4
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_ODMIMAGE_FILE_SYSTEM_TYPE     := ext4
TARGET_COPY_OUT_VENDOR  := vendor
TARGET_COPY_OUT_PRODUCT := product
TARGET_COPY_OUT_ODM     := odm

# NO es A/B
AB_OTA_UPDATER := false

# ============================================================
# FILESYSTEM — F2FS + ICE
# ro.crypto.type=file, ro.crypto.state=encrypted
# ============================================================
TARGET_USERIMAGES_USE_F2FS := true
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_HW_DISK_ENCRYPTION     := false
BOARD_USES_QCOM_FBE_DECRYPTION := true

# ============================================================
# VNDK
# ro.vndk.version=31 — vendor blobs son de Android 12
# Sistema (LOS 20) provee Android 13, vendor queda en 31
# ============================================================
BOARD_VNDK_VERSION := current

# ============================================================
# AVB (Verified Boot)
# ro.boot.vbmeta.device_state=unlocked → bootloader desbloqueado
# vbmeta → mmcblk0p17
# ============================================================
BOARD_AVB_ENABLE := true
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3
BOARD_AVB_RECOVERY_KEY_PATH             := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_RECOVERY_ALGORITHM           := SHA256_RSA4096
BOARD_AVB_RECOVERY_ROLLBACK_INDEX      := 1
BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION := 1

# ============================================================
# SELinux
# ============================================================
BOARD_PLAT_PRIVATE_SEPOLICY_DIR  += $(DEVICE_PATH)/sepolicy/private
BOARD_VENDOR_SEPOLICY_DIRS       += $(DEVICE_PATH)/sepolicy/vendor
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/system_ext

# ============================================================
# WiFi — hardware qcwcn
# ro.hardware=qcom, BOARD_HAS_QCOM_WLAN
# ============================================================
BOARD_HAS_QCOM_WLAN              := true
BOARD_WLAN_DEVICE                := qcwcn
WPA_SUPPLICANT_VERSION           := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER      := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_HOSTAPD_DRIVER             := NL80211
BOARD_HOSTAPD_PRIVATE_LIB        := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
WIFI_DRIVER_FW_PATH_STA          := "sta"
WIFI_DRIVER_FW_PATH_AP           := "ap"
WIFI_HIDL_UNIFIED_SUPPLICANT_SERVICE_RC_ENTRY := true

# ============================================================
# Bluetooth — SoC Pronto (wcnss)
# ro.vendor.bluetooth.wipower=false
# persist.vendor.qcom.bluetooth.enable.splita2dp=false
# ============================================================
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(DEVICE_PATH)/bluetooth
BLUETOOTH_HCI_USE_MCT := true
QCOM_BT_USE_BTNV      := true

# ============================================================
# Display — Adreno 505
# ro.sf.lcd_density=320, ro.hardware.egl=adreno
# ============================================================
TARGET_USES_ION                       := true
TARGET_USES_GRALLOC1                  := true
TARGET_USES_HWC2                      := true
MAX_VIRTUAL_DISPLAY_DIMENSION         := 4096
TARGET_FORCE_HWC_FOR_VIRTUAL_DISPLAYS := true
TARGET_SCREEN_DENSITY                 := 320

# ============================================================
# Recovery
# ============================================================
TARGET_RECOVERY_FSTAB        := $(DEVICE_PATH)/rootdir/etc/recovery.fstab
BOARD_INCLUDE_RECOVERY_DTBO  := true
TARGET_RECOVERY_PIXEL_FORMAT := "RGBX_8888"
TARGET_USES_MKE2FS           := true

# ============================================================
# Seguridad
# ro.vendor.build.security_patch=2023-08-01
# ============================================================
VENDOR_SECURITY_PATCH := 2023-08-01

# ============================================================
# Properties
# ============================================================
TARGET_SYSTEM_PROP += $(DEVICE_PATH)/system.prop
TARGET_VENDOR_PROP += $(DEVICE_PATH)/vendor.prop
