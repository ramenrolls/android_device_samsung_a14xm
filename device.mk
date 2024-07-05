#
# Copyright (C) 2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Enable updating of APEXes
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# Enable DeviceAsWebcam
PRODUCT_VENDOR_PROPERTIES += \
    ro.usb.uvc.enabled=true

# API levels
PRODUCT_SHIPPING_API_LEVEL := 33

# fastbootd
PRODUCT_PACKAGES += \
    android.hardware.fastboot@1.1-impl-mock \
    fastbootd

# Health
PRODUCT_PACKAGES += \
    android.hardware.health@2.1-impl \
    android.hardware.health@2.1-impl.recovery \
    android.hardware.health@2.1-service

# ######################
# GRAPHICS #
# ######################
TARGET_USES_VULKAN = true

## HWComposer
PRODUCT_VENDOR_PROPERTIES += ro.hardware.hwcomposer=mtk_common

PRODUCT_PACKAGES += \
	android.hardware.graphics.mapper@4.0-impl \
	android.hardware.graphics.allocator-V1-service \

# Mali Configuration Properties
# b/221255664 prevents setting PROTECTED_MAX_CORE_COUNT=2
PRODUCT_VENDOR_PROPERTIES += \
	vendor.mali.base_protected_tls_max=67108864 \
	vendor.mali.platform_agt_frequency_khz=24576

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
    android.hardware.graphics.composer@2.1-service

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
PRODUCT_ENFORCE_RRO_TARGETS := *

# Partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Product characteristics
PRODUCT_CHARACTERISTICS := phone

# Rootdir
PRODUCT_PACKAGES += \
    init.insmod.sh \
    install-recovery.sh \

PRODUCT_PACKAGES += \
    fstab.enableswap \
    factory_init.connectivity.common.rc \
    factory_init.connectivity.rc \
    factory_init.project.rc \
    factory_init.rc \
    init.aee.rc \
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

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

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
    libutils-v32

PRODUCT_PACKAGES += \
    android.hardware.drm-service.clearkey \
    android.hardware.drm@1.4.vendor \
    libprotobuf-cpp-lite-3.9.1-vendorcompat

# OpenMAX IL
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/conf/media/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
	$(LOCAL_PATH)/conf/media//media_codecs_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml

## Netflix BSP
PRODUCT_VENDOR_PROPERTIES += \
    ro.netflix.bsp_rev=MTK6833-32817-1

## VIDEO 
####################################


# Inherit the proprietary files
$(call inherit-product, vendor/samsung/a14xm/a14xm-vendor.mk)
