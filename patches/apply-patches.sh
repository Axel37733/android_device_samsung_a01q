#!/bin/bash
TOPDIR=$(dirname "$0")/../../../..
patch -p0 -d "$TOPDIR" < "$TOPDIR/device/samsung/a01q/patches/build_make/0001-skip-vintf-check.patch" && echo "Patch applied OK" || echo "Patch already applied or failed"
