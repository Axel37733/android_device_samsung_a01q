# Copyright (C) 2025 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Inherit from those products, Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)

# Inherit from a01q device
$(call inherit-product, device/samsung/a01q/device.mk)

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

PRODUCT_CHARACTERISTICS := default

PRODUCT_DEVICE := a01q
PRODUCT_NAME := lineage_a01q
PRODUCT_BRAND := samsung
PRODUCT_MODEL := SM-A015F
PRODUCT_MANUFACTURER := samsung

PRODUCT_SYSTEM_NAME := a01qxx

TARGET_VENDOR := samsung
TARGET_VENDOR_PRODUCT_NAME := a01q

PRODUCT_GMS_CLIENTID_BASE := android-samsung-ss

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="a01qxx-user 11 RP1A.200720.012 A015FXXU5BVG2 release-keys"

# Set BUILD_FINGERPRINT variable to be picked up by both system and vendor build.prop
BUILD_FINGERPRINT := "samsung/a01qxx/a01q:11/RP1A.200720.012/A015FXXU5BVG2:user/release-keys"

# Shipping API
PRODUCT_SHIPPING_API_LEVEL := 29
