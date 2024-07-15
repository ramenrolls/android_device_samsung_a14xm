#
# Copyright (C) 2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Enable updating of APEXes
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# Installs gsi keys into ramdisk, to boot a developer GSI with verified boot.
$(call inherit-product, $(SRC_TARGET_DIR)/product/developer_gsi_keys.mk)

# Enable DeviceAsWebcam
PRODUCT_VENDOR_PROPERTIES += \
    ro.usb.uvc.enabled=true

# Enable Dalvik Optimizations
PRODUCT_DEXPREOPT_SPEED_APPS += SystemUI  # For AOSP

# Compile SystemUI on device with `speed`.
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.systemuicompilerfilter=speed
    
# Use 64-bit dex2oat for better dexopt time.
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.dex2oat64.enabled=true

# Inherit Dalvik Properties 
$(call inherit-product, frameworks/native/build/phone-xhdpi-4096-dalvik-heap.mk)

# Virtual A/B OTA
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/vabc_features.mk)

# PostInstall Configuration
AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/mtk_plpath_utils \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/checkpoint_gc \
    FILESYSTEM_TYPE_vendor=ext4 \
    POSTINSTALL_OPTIONAL_vendor=true

PRODUCT_PACKAGES += \
    checkpoint_gc \
    otapreopt_script

PRODUCT_PACKAGES += \
    update_engine \
    update_engine_sideload \
    update_verifier


# API levels
PRODUCT_SHIPPING_API_LEVEL := 33

##########################
# Audio 
##########################

# AudioHAL Configurations
PRODUCT_PACKAGES += \
    android.hardware.audio.service \
    android.hardware.audio@7.0-impl \
    android.hardware.audio.effect@7.0-impl \
    android.hardware.soundtrigger@2.3-impl:32
   
PRODUCT_PACKAGES += \
    audio.bluetooth.default \
    audio.r_submix.default \
    audio.usb.default

PRODUCT_PACKAGES += \
    libtinycompress \
    libtinyxml \
    tinymix

PRODUCT_PACKAGES += \
    MtkInCallService
    PowerOffAlarm
    
PRODUCT_COPY_FILES += \
	frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration_7_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_audio_policy_configuration_7_0.xml \
	frameworks/av/services/audiopolicy/config/a2dp_in_audio_policy_configuration_7_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_in_audio_policy_configuration_7_0.xml \
	frameworks/av/services/audiopolicy/config/hearing_aid_audio_policy_configuration_7_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/hearing_aid_audio_policy_configuration_7_0.xml \
	frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
	frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml \
	frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
	frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
	frameworks/av/services/audiopolicy/config/bluetooth_audio_policy_configuration_7_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_audio_policy_configuration_7_0.xml

PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/configs/audio/,$(TARGET_COPY_OUT_VENDOR)/etc)

PRODUCT_PROPERTY_OVERRIDES += \
    aaudio.mmap_exclusive_policy=2 \
    aaudio.mmap_policy=2 

# MTK BesLoudness
ifeq ($(strip $(MTK_BESLOUDNESS_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_besloudness_support=1
endif

# Audio: must using XML format for Treblized devices
USE_XML_AUDIO_POLICY_CONF := 1


# Audio - end
##########################

# fastbootd
PRODUCT_PACKAGES += \
    android.hardware.fastboot@1.1-impl-mock \
    fastbootd

# HIDL
PRODUCT_PACKAGES += \
    android.hidl.base@1.0 \
    android.hidl.allocator@1.0 \
    android.hidl.base@1.0.vendor \
    android.hidl.allocator@1.0.vendor \
    libhidltransport \
    libhidltransport.vendor \
    libhwbinder \
    libhwbinder.vendor

# Health
PRODUCT_PACKAGES += \
    android.hardware.health@2.1-impl \
    android.hardware.health@2.1-impl.recovery \
    android.hardware.health@2.1-service

PRODUCT_PACKAGES += \
    android.hardware.health-V1-ndk \
    android.hardware.health@2.0

# Input
PRODUCT_PACKAGES += \
    android.hardware.biometrics.fingerprint@2.1-service.mt6833

PRODUCT_PACKAGES += \
    libvendor.goodix.hardware.biometrics.fingerprint@2.1.vendor

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/conf/idc/uinput-fpc.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/uinput-fpc.idc \
    $(LOCAL_PATH)/conf/idc/uinput-goodix.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/uinput-goodix.idc

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/conf/keylayout/uinput-fpc.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/uinput-fpc.kl \
    $(LOCAL_PATH)/conf/keylayout/uinput-goodix.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/uinput-goodix.kl

# Importing Fonts
$(call inherit-product-if-exists, frameworks/base/data/fonts/fonts.mk)
$(call inherit-product-if-exists, external/naver-fonts/fonts.mk)
$(call inherit-product-if-exists, external/noto-fonts/fonts.mk)
$(call inherit-product-if-exists, external/roboto-fonts/fonts.mk)
$(call inherit-product-if-exists, frameworks/base/data/fonts/openfont/fonts.mk)

# Fingerprint antispoof property
PRODUCT_PRODUCT_PROPERTIES +=\
    persist.vendor.fingerprint.disable.fake.override=none

##########################
# Bluetooth 
##########################

# Bluetooth
PRODUCT_PACKAGES += \
    android.hardware.bluetooth.audio-impl \
    android.hardware.bluetooth@1.1.vendor \
    libbluetooth_audio_session

PRODUCT_PACKAGES += \
    audio.bluetooth.default \
    libbluetooth_audio_session

# Bluetooth COD
## Service Field: 0x5A -> 90
PRODUCT_PRODUCT_PROPERTIES += \
    bluetooth.device.class_of_device=90,66,12
## MINOR_CLASS: 0x0C -> 12 (Smart Phone)

# Setting BT enabled profiles
PRODUCT_PRODUCT_PROPERTIES += \
    bluetooth.profile.a2dp.source.enabled?=true \
    bluetooth.profile.avrcp.target.enabled?=true \
    bluetooth.profile.gatt.enabled?=true \
    bluetooth.profile.hfp.ag.enabled?=true \
    bluetooth.profile.hid.device.enabled?=true \
    bluetooth.profile.hid.host.enabled?=true \
    bluetooth.profile.map.server.enabled?=true \
    bluetooth.profile.opp.enabled?=true \
    bluetooth.profile.pan.nap.enabled?=true \
    bluetooth.profile.pan.panu.enabled?=true \
    bluetooth.profile.pbap.server.enabled?=true \
    bluetooth.profile.sap.server.enabled?=true \


# Bluetooth - end
##########################
# Cgroup
PRODUCT_COPY_FILES += \
    system/core/libprocessgroup/profiles/cgroups_30.json:$(TARGET_COPY_OUT_VENDOR)/etc/cgroups.json \

# Camera
PRODUCT_PACKAGES += \
    android.hardware.camera.common@1.0.vendor \
    android.hardware.camera.device@3.3.vendor \
    android.hardware.camera.device@3.4.vendor \
    android.hardware.camera.device@3.5.vendor \
    android.hardware.camera.device@3.6.vendor \
    android.hardware.camera.provider@2.4.vendor \
    android.hardware.camera.provider@2.5.vendor \
    android.hardware.camera.provider@2.6.vendor \

# ConsumerIr
PRODUCT_PACKAGES += \
    android.hardware.ir@1.0-impl \
    android.hardware.ir@1.0-service

# ######################
# GRAPHICS #
# ######################
TARGET_USES_VULKAN = true

## HWComposer
PRODUCT_VENDOR_PROPERTIES += ro.hardware.hwcomposer=mtk_common

PRODUCT_PACKAGES += \
	android.hardware.graphics.mapper@4.0-impl \
    android.hardware.graphics.mapper@4.0.vendor \
	android.hardware.graphics.allocator-V1-service \
    android.hardware.graphics.common@1.2.vendor \

PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml \
	frameworks/native/data/etc/android.hardware.vulkan.version-1_3.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version.xml \
	frameworks/native/data/etc/android.hardware.vulkan.level-1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level.xml \
	frameworks/native/data/etc/android.hardware.vulkan.compute-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.compute.xml \
	frameworks/native/data/etc/android.software.vulkan.deqp.level-2023-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.vulkan.deqp.level.xml \
	frameworks/native/data/etc/android.software.contextualsearch.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.contextualsearch.xml \
	frameworks/native/data/etc/android.software.opengles.deqp.level-2023-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.opengles.deqp.level.xml

PRODUCT_VENDOR_PROPERTIES += \
	ro.hardware.vulkan = mali \
	ro.hardware.egl = meow \
	ro.opengles.version=196610 \

PRODUCT_VENDOR_PROPERTIES += ro.gfx.driver.0=com.mediatek.mt6833.gamedriver 

PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@4.0.vendor \
    android.hardware.graphics.composer@2.1-service \
    android.hardware.memtrack-service.mediatek-mali

# Render API properties   
PRODUCT_VENDOR_PROPERTIES += \
    ro.surface_flinger.protected_contents=true \
    ro.surface_flinger.force_hwc_copy_for_virtual_displays=true \
    ro.surface_flinger.max_frame_buffer_acquired_buffers=3 \
    ro.surface_flinger.primary_display_orientation=ORIENTATION_0 \

# Backend 
PRODUCT_PROPERTY_OVERRIDES += \
    debug.renderengine.backend=skiagl

# GRAPHICS # - end
######################

# Overlays
DEVICE_PACKAGE_OVERLAYS += \
    $(LOCAL_PATH)/overlay-lineage

PRODUCT_ENFORCE_RRO_TARGETS := *

PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += \
    $(LOCAL_PATH)/overlay-lineage

PRODUCT_PACKAGES += \
    CarrierConfigOverlayMT6833 \
    FrameworksResOverlayMT6833 \
    SettingsOverlayMT6833 \
    TelephonyOverlayMT6833 \
    TetheringConfigOverlayMT6833 \
    WifiOverlayMT6833
    
# Partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Product characteristics
PRODUCT_CHARACTERISTICS := phone

# Power
PRODUCT_PACKAGES += \
    android.hardware.power-service.mediatek-libperfmgr

PRODUCT_PACKAGES += \
    libmtkperf_client_vendor \
    libmtkperf_client

PRODUCT_PACKAGES += \
    vendor.mediatek.hardware.mtkpower@1.0.vendor \
    vendor.mediatek.hardware.mtkpower@1.1.vendor \
    vendor.mediatek.hardware.mtkpower@1.2-service.stub

PRODUCT_PACKAGES += \
    android.hardware.power@1.0.vendor \
    android.hardware.power@1.1.vendor \
    android.hardware.power@1.2.vendor \
    android.hardware.power@1.3.vendor

# Lights
PRODUCT_PACKAGES += \
    android.hardware.light-service.mt6833
################################
### Radio ## Telephony ## RIL
################################

# Radio
PRODUCT_PACKAGES += \
    android.hardware.radio.config@1.3.vendor \
    android.hardware.radio@1.6.vendor

# Multi SIM(DSDS)
SIM_COUNT := 2
$(call soong_config_set,sim,sim_count,$(SIM_COUNT))
SUPPORT_MULTI_SIM := true
# Support NR
SUPPORT_NR := true
# Using IRadio #
# Support SecureElement HAL for HIDL
USE_SE_HIDL := true

# FM
PRODUCT_PACKAGES += FMRadio

# RIL system props
PRODUCT_PROPERTY_OVERRIDES += \
    ro.telephony.default_network=26 \
    vendor.rild.libpath=/vendor/lib64/libsec-ril.so \
    vendor.rild.libargs=-d /dev/ttyC0 

# GNSS
PRODUCT_PACKAGES += \
    android.hardware.gnss@1.0.vendor \
    android.hardware.gnss@1.1.vendor \
    android.hardware.gnss@2.0.vendor \
    android.hardware.gnss@2.1.vendor \
    android.hardware.gnss.measurement_corrections@1.0.vendor \
    android.hardware.gnss.measurement_corrections@1.1.vendor \
    android.hardware.gnss.visibility_control@1.0.vendor
    
PRODUCT_PROPERTY_OVERRIDES += \
    ro.radio.noril=no

# No reboot on modem change
PRODUCT_PRODUCT_PROPERTIES += \
	persist.radio.reboot_on_modem_change=false

# Default to DSDS
PRODUCT_PRODUCT_PROPERTIES += \
	persist.radio.multisim.config=dsds

# DSDS - Dual SIM Dual Standby
# device has two separate radio interfaces
# one for each SIM 
# one SIM used for call, the other SIM is in standby mode
# Receiving a call on the standby SIM
# device will automatically switch to answer the call

# IMS
PRODUCT_BOOT_JARS += \
    mediatek-common \
    mediatek-framework \
    mediatek-ims-base \


### Radio ## Telephony ## RIL ###
#################################
# Secure Element
PRODUCT_PACKAGES += \
    android.hardware.secure_element@1.2.vendor

PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0-impl \
    android.hardware.gatekeeper@1.0-service

PRODUCT_PACKAGES += \
    android.hardware.keymaster@4.1.vendor \
    android.hardware.hardware_keystore.km41.xml \
    libkeymaster4_1support.vendor \
    libkeymaster41.vendor \
    libpuresoftkeymasterdevice.vendor \
    libsoft_attestation_cert.vendor

# Rootdir
PRODUCT_PACKAGES += \
    init.insmod.sh \

PRODUCT_PACKAGES += \
    fstab.enableswap \
    factory_init.connectivity.common.rc \
    factory_init.connectivity.rc \
    factory_init.project.rc \
    factory_init.rc \
    init.ago.rc \
    init.connectivity.common.rc \
    init.connectivity.rc \
    init.modem.rc \
    init.mt6833.rc \
    init.mt6833.usb.rc \
    init.project.rc \
    init.sec.rc \
    init.sensor_2_0.rc \
    init_connectivity.rc \
    meta_init.connectivity.common.rc \
    meta_init.connectivity.rc \
    meta_init.modem.rc \
    meta_init.project.rc \
    meta_init.rc \
    meta_init.vendor.rc \
    multi_init.rc \
    init.recovery.mt6833.rc \
    init.recovery.samsung.rc \

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/fstab.enableswap:$(TARGET_COPY_OUT_RAMDISK)/fstab.enableswap

# Sensors
PRODUCT_PACKAGES += \
    android.hardware.sensors@1.0.vendor \
    android.hardware.sensors@2.0.vendor \
    android.frameworks.sensorservice@1.0 \
    android.frameworks.sensorservice@1.0.vendor

PRODUCT_PACKAGES += \
    libshim_sensors \
    libsensorndkbridge

# Shims
PRODUCT_PACKAGES += \
    libshim_audio \

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH) \
    hardware/google/interfaces \
    hardware/google/pixel \
    hardware/mediatek \
    hardware/samsung

################################
# Thermal  
################################
PRODUCT_PACKAGES += \
    android.hardware.thermal@1.0-impl \
    android.hardware.thermal@2.0.vendor \
    android.hardware.thermal-service.mediatek \

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/conf/thermal_info_config.json:$(TARGET_COPY_OUT_VENDOR)/etc/thermal_info_config.json \
    $(LOCAL_PATH)/conf/task_profiles.json:$(TARGET_COPY_OUT_VENDOR)/etc/task_profiles.json

# Thermal  - end
################################
# Use FUSE passthrough
PRODUCT_PRODUCT_PROPERTIES += \
	persist.sys.fuse.passthrough.enable=true \
	sys.fuse.transcode_enabled \
	persist.sys.fuse=true \

## No FUSE BPF implementation

# USB
PRODUCT_PACKAGES += \
    android.hardware.usb-service.mediatek-legacy \
    android.hardware.usb.gadget-service.mediatek

####################################
## VIDEO
####################################

# Codec 2.0
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/conf/media/media_codecs_c2.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_c2.xml \

PRODUCT_PROPERTY_OVERRIDES += media.c2.dmabuf.padding=3072 

# Create input surface on the framework side
PRODUCT_PROPERTY_OVERRIDES += \
	debug.stagefright.c2inputsurface=-1 \

PRODUCT_PACKAGES += \
    libavservices_minijail_vendor \
    libcodec2_hidl@1.2.vendor \
    libcodec2_soft_common.vendor \
    libsfplugin_ccodec_utils.vendor \
    libstagefright_softomx_plugin.vendor \
    libstagefright_foundation-v33

PRODUCT_PACKAGES += \
    libdrm.vendor \
    libdrm

PRODUCT_PACKAGES += \
    android.hardware.drm-service.clearkey \
    android.hardware.drm@1.4.vendor \

PRODUCT_PACKAGES += \
    android.hardware.drm-service.clearkey \

PRODUCT_PACKAGES += \
    libmockdrmcryptoplugin

PRODUCT_PACKAGES += \
    android.hardware.drm@1.0.vendor \
    android.hardware.drm@1.1.vendor \
    android.hardware.drm@1.2.vendor \
    android.hardware.drm@1.3.vendor

# OpenMAX IL
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/conf/media/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
	$(LOCAL_PATH)/conf/media//media_codecs_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml

## Netflix BSP
PRODUCT_VENDOR_PROPERTIES += \
    ro.netflix.bsp_rev=MTK6833-32817-1

## VIDEO 
####################################

# NFC
PRODUCT_PACKAGES += \
    android.hardware.nfc-service.st \
    com.android.nfc_extras \
    NfcNci \
    Tag

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/nfc/libnfc-hal-st.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libnfc-hal-st.conf \
    $(LOCAL_PATH)/configs/nfc/libnfc-nci.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libnfc-nci.conf

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.nfc.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/sku_nfc/android.hardware.nfc.xml \
    frameworks/native/data/etc/android.hardware.nfc.ese.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/sku_nfc/android.hardware.nfc.ese.xml \
    frameworks/native/data/etc/android.hardware.nfc.hce.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/sku_nfc/android.hardware.nfc.hce.xml \
    frameworks/native/data/etc/android.hardware.nfc.hcef.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/sku_nfc/android.hardware.nfc.hcef.xml \
    frameworks/native/data/etc/android.hardware.nfc.uicc.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/sku_nfc/android.hardware.nfc.uicc.xml

PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/conf/nfc,$(TARGET_COPY_OUT_VENDOR)/etc)

# Vibrator
PRODUCT_PACKAGES += \
    android.hardware.vibrator-service.mediatek \


# WiFi
PRODUCT_PACKAGES += \
    android.hardware.wifi-service \
    hostapd \
    wpa_supplicant

PRODUCT_PACKAGES += \
    libwifi-hal-wrapper

PRODUCT_PACKAGES += \
    android.hardware.tetheroffload.config@1.0.vendor \
    android.hardware.tetheroffload.control@1.1.vendor

# Inherit the proprietary files
$(call inherit-product, vendor/samsung/a14xm/a14xm-vendor.mk)
