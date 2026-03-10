#!/usr/bin/env bash
# setup_kernel.sh — Samsung Galaxy A01q (SM-A015M)
# Extrae y ubica el kernel source en el árbol AOSP/LineageOS
#
# Confirmado por README_Kernel.txt:
#   ARCH=arm64, defconfig=samsung/a01q_eur_open_defconfig
#   Toolchain: aarch64-linux-android-4.9 + clang 10.0
#   Output: arch/arm64/boot/Image
#
# Uso (desde la RAÍZ de tu AOSP/LineageOS):
#   bash device/samsung/a01q/setup_kernel.sh /ruta/a/SM-A015M_LATIN_12_Opensource

set -e

G='\033[0;32m'; Y='\033[1;33m'; R='\033[0;31m'; B='\033[0;34m'; N='\033[0m'
info()  { echo -e "${G}[INFO]${N}  $*"; }
warn()  { echo -e "${Y}[WARN]${N}  $*"; }
error() { echo -e "${R}[ERROR]${N} $*" >&2; exit 1; }
title() { echo -e "\n${B}=== $* ===${N}"; }

SOURCE_DIR="${1:-}"
KERNEL_DEST="kernel/samsung/msm8937"

[[ -f "build/envsetup.sh" ]] || \
    error "Corré este script desde la raíz del árbol AOSP/LineageOS"
[[ -n "$SOURCE_DIR" ]] || \
    error "Uso: bash device/samsung/a01q/setup_kernel.sh /ruta/a/SM-A015M_LATIN_12_Opensource"
[[ -d "$SOURCE_DIR" ]] || error "No se encuentra: $SOURCE_DIR"
[[ -f "$SOURCE_DIR/Kernel.tar.gz" ]] || error "No se encuentra Kernel.tar.gz en $SOURCE_DIR"

title "Extrayendo kernel source"
mkdir -p "$KERNEL_DEST"
tar -xzf "$SOURCE_DIR/Kernel.tar.gz" -C "$KERNEL_DEST" --strip-components=1
[[ -f "$KERNEL_DEST/Makefile" ]] || error "Extracción falló"
KVER=$(awk '/^VERSION/{v=$3}/^PATCHLEVEL/{p=$3}/^SUBLEVEL/{s=$3}END{print v"."p"."s}' "$KERNEL_DEST/Makefile")
info "Kernel extraído: $KVER ✓"

title "Verificando defconfig"
DEFCONFIG="$KERNEL_DEST/arch/arm64/configs/samsung/a01q_eur_open_defconfig"
if [[ -f "$DEFCONFIG" ]]; then
    info "arch/arm64/configs/samsung/a01q_eur_open_defconfig ✓"
else
    warn "Defconfig no encontrado en arm64/configs/samsung/ — buscando:"
    find "$KERNEL_DEST/arch" -name "*a01q*" 2>/dev/null || echo "  Sin resultados"
fi

title "Aplicando fragmento LineageOS 20"
mkdir -p "$KERNEL_DEST/arch/arm64/configs"
cat > "$KERNEL_DEST/arch/arm64/configs/lineage_a01q.config" << 'KCONFIG'
# Fragmento sobre samsung/a01q_eur_open_defconfig para LineageOS 20 / Android 13
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_BPF=y
CONFIG_BPF_SYSCALL=y
CONFIG_BPF_JIT=y
CONFIG_CGROUP_BPF=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_SECCOMP=y
CONFIG_SECCOMP_FILTER=y
CONFIG_F2FS_FS=y
CONFIG_F2FS_FS_XATTR=y
CONFIG_F2FS_FS_POSIX_ACL=y
CONFIG_F2FS_FS_SECURITY=y
CONFIG_QCOM_ICE=y
CONFIG_QCOM_FS_ENCRYPTION=y
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_XTS=y
CONFIG_ZRAM=y
CONFIG_ZSMALLOC=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_ION=y
CONFIG_ION_MSM=y
CONFIG_BUILD_ARM64_DT_OVERLAY=y
KCONFIG
info "Fragmento guardado: arch/arm64/configs/lineage_a01q.config"

title "Verificando toolchain GCC"
GCC="prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-gcc"
if [[ -f "$GCC" ]]; then
    info "GCC aarch64-linux-android-4.9 ✓ — $("$GCC" --version | head -1)"
else
    warn "GCC no encontrado — ejecutá 'repo sync' para descargarlo"
fi

echo ""
info "=== Listo ==="
echo -e "  Kernel:    ${G}$KERNEL_DEST${N} ($KVER)"
echo -e "  ARCH:      ${G}arm64${N} (kernel 64-bit + userspace 32-bit)"
echo -e "  Defconfig: ${G}samsung/a01q_eur_open_defconfig${N}"
echo -e "  Output:    ${G}arch/arm64/boot/Image${N}"
echo ""
echo "  Para compilar:"
echo "    source build/envsetup.sh"
echo "    lunch lineage_a01q-userdebug"
echo "    mka kernel    ← solo el kernel"
echo "    mka bacon     ← build completo"
