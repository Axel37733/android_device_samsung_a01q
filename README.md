# Device Tree — Samsung Galaxy A01q (SM-A015M)
## LineageOS 20 — Android 13 | Revisión 3

---

## Especificaciones verificadas

| Componente | Detalle | Fuente verificada |
|---|---|---|
| Modelo | SM-A015M (Sales code ARO — Argentina) | `getprop` |
| SOC | Qualcomm SDM439 (msm8937) | `/proc/cpuinfo` |
| CPU | 8× Cortex-A53 @ 1.95GHz (part: 0xd03) | `/proc/cpuinfo` |
| Modo kernel | armv8l (32-bit) sobre hardware AArch64 | `uname -a` |
| GPU | Adreno 505 | `ro.hardware.egl=adreno` |
| ABI del sistema | armeabi-v7a, armeabi | `ro.product.cpu.abilist` |
| RAM | 2GB | spec + dalvik props |
| Kernel | 4.9.227-24347433 (Sep 26 2023) | `uname -a` |
| Compilador kernel | clang 12.1.1 for Android NDK | `/proc/version` |
| Android stock | 12 (SDK 31, OneUI 4.0.1) | `ro.build.version` |
| Firmware | A015MUBS5CWI4 | `ro.build.version.incremental` |
| Partición super | mmcblk0p72 — **3,949,985,792 bytes** | `/proc/partitions` |
| Userdata | mmcblk0p78 — ≈24GB — F2FS + ICE | `df -h` |
| Boot device | soc/7824900.sdhci | `ro.boot.bootdevice` |
| Bootloader | DESBLOQUEADO (orange) | `ro.boot.verifiedbootstate` |
| Cifrado | File-Based Encryption (ICE) | `ro.crypto.type=file` |
| SIM | Single SIM | `persist.radio.multisim.config=ss` |
| Treble | Habilitado | `ro.treble.enabled=true` |
| FM Radio | Habilitado | `vendor.audio.feature.fm.enable=true` |
| GPS | Habilitado (GNSS) | `init.svc.gnss_service=running` |
| NFC | **NO tiene** | Sin prop de NFC |
| Fingerprint | **NO tiene** | Sin prop de biometrics |

---

## Estructura del device tree

```
device/samsung/a01q/
├── Android.mk
├── AndroidProducts.mk
├── BoardConfig.mk               ← particiones exactas del dispositivo
├── device.mk                    ← HALs Android 13 compatibles
├── extract-files.sh             ← extrae vendor blobs vía ADB
├── lineage_a01q.mk
├── lineage.dependencies
├── system.prop                  ← propiedades verificadas por getprop
├── vendor.prop
├── audio/
│   ├── audio_policy_configuration.xml   ← FM + HFP + HIFI configurados
│   └── audio_effects.xml                ← formato XML (Android 13)
├── bluetooth/
│   └── bdroid_buildcfg.h               ← Pronto/wcnss BT SoC
├── overlay/
│   └── frameworks/base/core/res/res/values/config.xml
├── prebuilt/                    ← PENDIENTE: zImage-dtb, dtb, dtbo.img
├── rootdir/etc/
│   ├── fstab.qcom               ← particiones verificadas
│   ├── recovery.fstab
│   ├── init.target.rc
│   └── init.qcom.power.rc
└── sepolicy/
    ├── private/file_contexts
    ├── vendor/file_contexts
    └── system_ext/              ← pendiente expandir
```


## Mapa completo de particiones

```
Partición    mmcblk    Bloques     Tamaño      Montaje
boot         p62       65536       64 MB       /boot
recovery     p61       65536       64 MB       /recovery
dtbo         p27       8192        8 MB        —
super        p72       3857408     3767 MB     (contiene system/vendor/product/odm)
cache        p75       143360      140 MB      /cache
metadata     p71       32768       32 MB       /metadata
persist      p54       32768       32 MB       /mnt/vendor/persist
prism        p73       204800      200 MB      /prism
optics       p74       20480       20 MB       /optics
omr          p76       20480       20 MB       /omr
sec_efs      p48       16384       16 MB       /efs
efs          p49       16384       16 MB       /mnt/vendor/efs
keydata      p70       16384       16 MB       /keydata
keyrefuge    p69       16384       16 MB       /keyrefuge
apnhlos      p67       65540       64 MB       /vendor/firmware_mnt
modem        p68       70140       68 MB       /vendor/firmware-modem
dsp          p5        16384       16 MB       /vendor/dsp
vbmeta       p17       512         0.5 MB      —
userdata     p78       25270252    ~24 GB      /data
```


## Compilación

```bash
# En el root del AOSP/LineageOS:
source build/envsetup.sh
lunch lineage_a01q-userdebug
brunch a01q

# O más explícito:
mka bacon -j$(nproc)
```

### Orden de dependencias antes de compilar

1. ✅ Device tree en `device/samsung/a01q/`
2. ⏳ Vendor blobs en `vendor/samsung/a01q/` → `./extract-files.sh`
3. ⏳ Kernel source en `kernel/samsung/msm8937/` ← descargando
4. `repo sync` para sincronizar dependencias de `lineage.dependencies`
