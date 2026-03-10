#!/usr/bin/env bash
# extract-files.sh — Samsung Galaxy A01q (SM-A015M)
# Extrae vendor blobs vía ADB para LineageOS 20 (Android 13)
# Target: vendor/samsung/a01q/
#
# Uso:
#   adb root
#   bash extract-files.sh [directorio_destino]

set -e

VENDOR="samsung"
DEVICE="a01q"
DEST="${1:-../../../vendor/${VENDOR}/${DEVICE}}"

# Colores
R='\033[0;31m' G='\033[0;32m' Y='\033[1;33m' B='\033[0;34m' N='\033[0m'
info()  { echo -e "${G}[INFO]${N}  $*"; }
warn()  { echo -e "${Y}[WARN]${N}  $*"; }
error() { echo -e "${R}[ERROR]${N} $*" >&2; exit 1; }
title() { echo -e "\n${B}=== $* ===${N}"; }

# ============================================================
# Verificar ADB
# ============================================================
command -v adb &>/dev/null || error "adb no encontrado en PATH"
adb wait-for-device

MODEL=$(adb shell getprop ro.product.model 2>/dev/null | tr -d '\r\n')
DEV=$(adb shell getprop ro.product.device 2>/dev/null | tr -d '\r\n')
FW=$(adb shell getprop ro.build.version.incremental 2>/dev/null | tr -d '\r\n')

info "Dispositivo: $MODEL ($DEV) — Firmware: $FW"
[[ "$DEV" == "a01q" ]] || { warn "Dispositivo '$DEV' no es a01q"; read -rp "¿Continuar? [s/N] " r; [[ "$r" =~ ^[sS]$ ]] || exit 1; }

# Root
adb root &>/dev/null && sleep 2 || warn "Sin root — algunos blobs pueden faltar"

# ============================================================
# Preparar directorios
# ============================================================
mkdir -p "$DEST"/{lib/{hw,egl,rfsa/adsp},lib64/{hw,egl},bin,etc/{firmware,wifi,bluetooth,sensors,gps},app,priv-app}

info "Directorio destino: $(realpath "$DEST")"

PULLED=0; FAILED=0

pull() {
    local src="$1" dst="${DEST}/${2:-${1#/}}"
    mkdir -p "$(dirname "$dst")"
    if adb pull "$src" "$dst" 2>/dev/null; then
        echo -e "  ${G}✓${N} $src"
        ((PULLED++)); return 0
    else
        echo -e "  ${R}✗${N} $src"
        ((FAILED++)); return 1
    fi
}

# ============================================================
title "GPU / EGL — Adreno 505"
# ============================================================
for f in libgsl.so libOpenCL.so libOpenVX.so libOpenVXU.so \
          libq3dtools_adreno.so libQTapGLES.so; do
    pull /vendor/lib/$f lib/$f
done
pull /vendor/lib/egl/libEGL_adreno.so         lib/egl/libEGL_adreno.so
pull /vendor/lib/egl/libGLESv1_CM_adreno.so   lib/egl/libGLESv1_CM_adreno.so
pull /vendor/lib/egl/libGLESv2_adreno.so      lib/egl/libGLESv2_adreno.so
pull /vendor/lib/egl/libGLESv3_adreno.so      lib/egl/libGLESv3_adreno.so
pull /vendor/lib/hw/gralloc.msm8937.so        lib/hw/gralloc.msm8937.so
pull /vendor/lib/hw/hwcomposer.msm8937.so     lib/hw/hwcomposer.msm8937.so
pull /vendor/lib/hw/memtrack.msm8937.so       lib/hw/memtrack.msm8937.so

# ============================================================
title "WiFi — wcnss / qcwcn"
# ============================================================
pull /vendor/lib/hw/wifi.msm8937.so           lib/hw/wifi.msm8937.so
pull /vendor/lib/libwpa_client.so             lib/libwpa_client.so
pull /vendor/lib/libcld80211.so               lib/libcld80211.so
pull /vendor/etc/wifi/WCNSS_qcom_cfg.ini      etc/wifi/WCNSS_qcom_cfg.ini
pull /vendor/etc/wifi/WCNSS_wlan_dictionary.dat etc/wifi/WCNSS_wlan_dictionary.dat
# Firmware wcnss
for ext in b00 b01 b02 b04 b06 b07 b08 b09 mdt; do
    pull /vendor/firmware/wcnss.$ext etc/firmware/wcnss.$ext
done
pull /vendor/firmware/wcnss_wlan.elf          etc/firmware/wcnss_wlan.elf

# ============================================================
title "Bluetooth — Pronto (wcnss)"
# ============================================================
pull /vendor/lib/hw/bluetooth.default.so      lib/hw/bluetooth.default.so
pull /vendor/lib/libbt-vendor.so              lib/libbt-vendor.so
pull /vendor/etc/bluetooth/bt_vendor.conf     etc/bluetooth/bt_vendor.conf

# ============================================================
title "Audio — msm8937"
# ============================================================
pull /vendor/lib/hw/audio.primary.msm8937.so   lib/hw/audio.primary.msm8937.so
for f in libaudio-resampler.so libacdbloader.so libacdbmapper.so \
         libaudcal.so libqcompostprocbundle.so libqcomvisualizer.so \
         libqcomvoiceprocessing.so libvolumelistener.so \
         libcsd-client.so libsurround_proc.so; do
    pull /vendor/lib/$f lib/$f
done
# Configs de audio
for cfg in audio_policy_configuration.xml mixer_paths.xml audio_output_policy.conf \
           audio_platform_info.xml sound_trigger_mixer_paths.xml; do
    pull /vendor/etc/$cfg etc/$cfg
done

# ============================================================
title "Cámara"
# ============================================================
pull /vendor/lib/hw/camera.msm8937.so         lib/hw/camera.msm8937.so
for f in libmmcamera_interface.so libmm-qcamera.so \
         libmmjpeg_interface.so libqomx_core.so \
         libqomx_jpegenc.so libqomx_jpegdec.so \
         libmmcamera2_stats_modules.so; do
    pull /vendor/lib/$f lib/$f
done

# ============================================================
title "RIL / Radio"
# ============================================================
for f in libril.so libsec-ril.so libsec-ril-dsds.so \
         libvndfwk_detect_jni.qti.so libQSEEComAPI.so \
         libdiag.so libmdmdetect.so librmnetctl.so; do
    pull /vendor/lib/$f lib/$f
done
pull /vendor/bin/rild bin/rild

# ============================================================
title "Sensores"
# ============================================================
pull /vendor/lib/hw/sensors.msm8937.so        lib/hw/sensors.msm8937.so
for f in libsensor1.so libsensor_reg.so; do
    pull /vendor/lib/$f lib/$f
done
pull /vendor/etc/sensors/sensor_def_qcomdev.conf etc/sensors/sensor_def_qcomdev.conf

# ============================================================
title "GPS / GNSS"
# ============================================================
pull /vendor/bin/gnss_service                 bin/gnss_service
for cfg in gps.conf flp.conf izat.conf lowi.conf sap.conf xtwifi.conf; do
    pull /vendor/etc/$cfg etc/gps/$cfg 2>/dev/null || \
    pull /vendor/etc/gps/$cfg etc/gps/$cfg
done
pull /vendor/lib/hw/gps.msm8937.so            lib/hw/gps.msm8937.so

# ============================================================
title "DRM / Keymaster / Gatekeeper"
# ============================================================
for f in hw/keystore.msm8937.so hw/gatekeeper.msm8937.so \
         libkeymaster_messages.so libdrmfs.so libdrmtime.so; do
    pull /vendor/lib/$f lib/$f
done

# ============================================================
title "Power / Thermal"
# ============================================================
pull /vendor/lib/hw/power.msm8937.so          lib/hw/power.msm8937.so
pull /vendor/lib/libthermalclient.so          lib/libthermalclient.so
pull /vendor/lib/libtime_genoff.so            lib/libtime_genoff.so
pull /vendor/etc/msm_irqbalance.conf          etc/msm_irqbalance.conf
pull /vendor/bin/thermal-engine               bin/thermal-engine

# ============================================================
title "IMS / VoLTE"
# ============================================================
for f in libimscamera_jni.so libimsmedia_jni.so \
         lib-imss.so lib-imsdpl.so lib-imsqimf.so \
         lib-imsvt.so lib-rtpcore.so lib-rtpsl.so \
         lib-uceservice.so; do
    pull /vendor/lib/$f lib/$f
done
pull /vendor/bin/ims_rtp_daemon               bin/ims_rtp_daemon
pull /vendor/bin/imsdatadaemon                bin/imsdatadaemon
pull /vendor/bin/imsqmidaemon                 bin/imsqmidaemon

# ============================================================
title "Binarios del sistema"
# ============================================================
for bin in adsprpcd rmt_storage netmgrd port-bridge qmuxd time_daemon; do
    pull /vendor/bin/$bin bin/$bin
done

# ============================================================
# Generar a01q-vendor.mk
# ============================================================
title "Generando a01q-vendor.mk"
cat > "$DEST/a01q-vendor.mk" << 'VENDORMK'
# Automatically generated by extract-files.sh
# DO NOT EDIT manually

$(call inherit-product, vendor/samsung/a01q/a01q-vendor-blobs.mk)
VENDORMK

info "Generado: $DEST/a01q-vendor.mk"

# ============================================================
title "Resumen"
# ============================================================
TOTAL=$(find "$DEST" -type f | wc -l)
echo ""
info "Archivos obtenidos: ${G}$PULLED${N}"
[[ $FAILED -gt 0 ]] && warn "Archivos no encontrados: $FAILED"
info "Total en destino:   $TOTAL archivos"
echo ""

# Verificar blobs críticos
echo -e "${B}Verificación de blobs críticos:${N}"
CRITICAL=(
    "lib/egl/libEGL_adreno.so"
    "lib/hw/audio.primary.msm8937.so"
    "lib/hw/gralloc.msm8937.so"
    "lib/hw/camera.msm8937.so"
    "lib/hw/sensors.msm8937.so"
    "lib/hw/wifi.msm8937.so"
    "lib/libsec-ril.so"
    "bin/rild"
    "etc/wifi/WCNSS_qcom_cfg.ini"
)
OK=0; MISSING=0
for f in "${CRITICAL[@]}"; do
    if [[ -f "$DEST/$f" ]]; then
        echo -e "  ${G}✓${N} $f"
        ((OK++))
    else
        echo -e "  ${R}✗${N} $f  ← FALTA"
        ((MISSING++))
    fi
done
echo ""
[[ $MISSING -gt 0 ]] && warn "$MISSING blobs críticos faltan — el build puede fallar"
[[ $MISSING -eq 0 ]] && info "Todos los blobs críticos presentes ✓"
echo ""
info "Próximo paso: crear a01q-vendor-blobs.mk con las reglas PRODUCT_COPY_FILES"
