#
# Copyright (C) 2024 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# WiFi
BOARD_WLAN_DEVICE := MediaTek 


PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(DEVICE_PATH)/conf/wifi/,$(TARGET_COPY_OUT_VENDOR)/etc/wifi)

# Add WIFI_FEATURE_IMU_DETECTION to soong_config
$(call soong_config_set,wifi,feature_imu_detection,$(WIFI_FEATURE_IMU_DETECTION))
