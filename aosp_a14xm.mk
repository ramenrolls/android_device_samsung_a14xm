#
# SPDX-FileCopyrightText: 2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from device makefile.
$(call inherit-product, device/samsung/a14xm/device.mk)

# Inherit some common stuff.
$(call inherit-product, vendor/aosp/config/common_full_phone.mk)

PRODUCT_NAME := aosp_a14xm
PRODUCT_DEVICE := a14xm
PRODUCT_MANUFACTURER := samsung
PRODUCT_BRAND := Samsung
PRODUCT_MODEL := SM-A146P

# Use the latest approved GMS identifiers
PRODUCT_GMS_CLIENTID_BASE := android-samsung-ss

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="a14xmxx-user 14 UP1A.231005.007 A146PXXSBDXL1 release-keys" \
    PRODUCT_DEVICE=a14xm \
    PRODUCT_NAME=a14xmxx \
    TARGET_BOOTLOADER_BOARD_NAME=a14xm \
BUILD_FINGERPRINT := "samsung/a14xmxx/a14xm:14/UP1A.231005.007/A146PXXSBDXL1:user/release-keys"