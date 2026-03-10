/*
 * bdroid_buildcfg.h — Samsung Galaxy A01q (SM-A015M)
 * Bluetooth SoC: Qualcomm Pronto (wcnss)
 * ro.vendor.bluetooth.wipower=false
 * persist.vendor.qcom.bluetooth.enable.splita2dp=false
 */

#ifndef _BDROID_BUILDCFG_H
#define _BDROID_BUILDCFG_H

/* Pronto no soporta Bluetooth 5.0 features */
#define BTM_DEF_LOCAL_NAME "Galaxy A01"

/* SCO codec — HFP habilitado: vendor.audio.feature.hfp.enable=true */
#define BTIF_HF_WBS_PREFERRED TRUE

/* A2DP split no habilitado */
#define BTA_AV_SPLIT_A2DP_DEF_FREQ_25HZ FALSE

/* Pronto SoC — no hay soporte de BLE extended advertising */
#define BLE_VND_INCLUDED TRUE

/* Nombre del vendor para identificación */
#define BT_CHIP_VENDOR "QCOM"
#define BT_CHIP_ID     "PRONTO"

/* PIN predeterminado */
#define BT_NET_IF_NAME "mbtun"

#endif /* _BDROID_BUILDCFG_H */
