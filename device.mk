#
# SPDX-FileCopyrightText: 2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Installs gsi keys into ramdisk, to boot a developer GSI with verified boot.
$(call inherit-product, $(SRC_TARGET_DIR)/product/developer_gsi_keys.mk)

# Dalvik VM Configuration
$(call inherit-product, frameworks/native/build/phone-xhdpi-4096-dalvik-heap.mk)

# Project ID Quota
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Declare as non AB device
$(call inherit-product, $(SRC_TARGET_DIR)/product/non_ab_device.mk)

## Audio HAL Server & Default Implementations
PRODUCT_PACKAGES += \
	android.hardware.audio.service \
	android.hardware.audio@7.1-impl \
	android.hardware.audio.effect@7.0-impl \
	android.hardware.soundtrigger@2.3-impl \
	android.hardware.bluetooth.audio-impl \

## Audio HAL libraries
PRODUCT_PACKAGES += \
	audio.primary.$(TARGET_BOARD_PLATFORM) \
	audio.r_submix.$(TARGET_BOARD_PLATFORM) \
	libaudioeffectoffload \
	libbundlewrapper \
	libreverbwrapper \
	libeffectproxy \
	libvisualizer \
	libdynproc \
	libdownmix \
	libldnhncr \
	libswdap \
	libmyspace \
	libswspatializer \
	audio.usb.default \
	libplaybackrecorder \
	audio.bluetooth.default \
	sound_trigger.primary.default

PRODUCT_PACKAGES += \
    libaudiopreprocessing_mtk

## Libraries for audio.primary
PRODUCT_PACKAGES += \
    libtinyalsa \
    libaudioroute \
    tinymix

PRODUCT_PACKAGES += \
    MtkInCallService

## AudioHAL Configurations
PRODUCT_COPY_FILES += \
	frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration_7_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_audio_policy_configuration_7_0.xml \
	frameworks/av/services/audiopolicy/config/a2dp_in_audio_policy_configuration_7_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_in_audio_policy_configuration_7_0.xml \
	frameworks/av/services/audiopolicy/config/hearing_aid_audio_policy_configuration_7_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/hearing_aid_audio_policy_configuration_7_0.xml \
	frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
	frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml \

# Bluetooth Audio AIDL HAL
PRODUCT_PACKAGES += \
    android.hardware.bluetooth.audio-impl \
PRODUCT_COPY_FILES += \
    frameworks/av/services/audiopolicy/config/bluetooth_audio_policy_configuration_7_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_audio_policy_configuration_7_0.xml \

# Dynamic Partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_BUILD_SUPER_PARTITION := false

PRODUCT_PACKAGES += \
    fastbootd

# Overlays
PRODUCT_ENFORCE_RRO_TARGETS := *

# Rootdir
PRODUCT_PACKAGES += \
    fstab.mt6833 \
    fstab.mt6833.ramdisk
    init.connectivity.common.rc \
    init.modem.rc \
    init.mt6833.rc \
    init.project.rc \
    init.sec.rc \
    init.sensor_2.0.rc \
    init_connectivity.rc \

PRODUCT_PACKAGES += \
    ueventd.mt6833.rc

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init/init.recovery.mt6833.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.mt6833.rc

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# Inherit the proprietary files
$(call inherit-product, vendor/samsung/a14xm/a14xm-vendor.mk)
