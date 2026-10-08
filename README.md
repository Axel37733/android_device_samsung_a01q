Device tree for the Samsung Galaxy A01/M01
=================================================

Status: Vendor VNDK32 Booted

  ## Device Specifications
 
  Basic | Spec Sheet
 -------:|:-------------------------
 SoC | Qualcomm MSM8937 Snapdragon 439
 CPU | Octa core (2.0 GHz)
 GPU | Adreno 505
 Memory | 2 GB RAM
 Shipped Android Version | 10.0
 Storage | 16/32 GB
 MicroSD | Up to 512 GB (dedicated slot)
 Battery | Non-removable Li-Polymer 3000 mAh battery
 Dimensions | 147.5 x 70.9 x 9.8 mm (5.81 x 2.79 x 0.39 in)
 Display | 720 x 1520 pixels, 19:9 ratio (~294 ppi density)
 Rear Camera (Main) | 13 MP, f/2.2, 28mm (wide), 1/3.1", 1.12µm, AF
 Rear Camera (Depth) | 2 MP, f/2.4, (depth)
 Front camera | 5 MP, f/2.2, 1/5", 1.12µm
 
 ## Device Picture
 
 ![Samsung Galaxy A01](https://fdn2.gsmarena.com/vv/pics/samsung/samsung-galaxy-a01-1.jpg)
## Required patch: ClatCoordinator (needed to boot)

Without this patch the ROM aborts in `system_server` (`verifyClatPerms()` fails). Run it from the **root of the ROM source tree** (the folder containing `build/` and `packages/`) after every `repo sync`. It makes a backup (`.bak`) and does nothing if it was already applied.

```bash
python3 << 'EOF'
import shutil
from pathlib import Path

FILE_PATH = Path("packages/modules/Connectivity/service/jni/com_android_server_connectivity_ClatCoordinator.cpp")

OLD_LINE = "    if (fatal) abort();"
NEW_LINE = '    if (fatal) ALOGE("verifyClatPerms failed but continuing (patched)");'

if not FILE_PATH.exists():
    print(f"[ERROR] No encontré el archivo en: {FILE_PATH}")
    exit(1)

content = FILE_PATH.read_text()

if NEW_LINE.strip() in content:
    print("[OK] El parche ya estaba aplicado. No se hizo nada.")
    exit(0)

if OLD_LINE not in content:
    print("[ERROR] No encontré la línea exacta a reemplazar. Revisá manualmente.")
    exit(1)

backup_path = FILE_PATH.with_suffix(FILE_PATH.suffix + ".bak")
shutil.copy2(FILE_PATH, backup_path)
print(f"[OK] Backup creado en: {backup_path}")

count = content.count(OLD_LINE)
if count != 1:
    print(f"[ADVERTENCIA] Encontré {count} ocurrencias, esperaba 1. Abortando.")
    exit(1)

new_content = content.replace(OLD_LINE, NEW_LINE)
FILE_PATH.write_text(new_content)

print("[OK] Parche aplicado correctamente.")
print(f"     Línea vieja: {OLD_LINE.strip()}")
print(f"     Línea nueva: {NEW_LINE.strip()}")

verify = FILE_PATH.read_text()
if NEW_LINE.strip() in verify and OLD_LINE.strip() not in verify:
    print("[OK] Verificación exitosa.")
else:
    print("[ERROR] Algo salió mal, revisá el archivo a mano.")
EOF
```
