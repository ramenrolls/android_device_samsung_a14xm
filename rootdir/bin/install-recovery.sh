#!/vendor/bin/sh
if ! applypatch --check EMMC:/dev/block/platform/bootdevice/by-name/recovery$(getprop ro.boot.slot_suffix):41943040:9f1c78ff87e91b0741d64467ba7c51f66d461833; then
  applypatch \
          --patch /vendor/recovery-from-boot.p \
          --source EMMC:/dev/block/platform/bootdevice/by-name/boot$(getprop ro.boot.slot_suffix):33554432:14c2835c6f240d4274a118967f2d3b19b22a6ebf \
          --target EMMC:/dev/block/platform/bootdevice/by-name/recovery$(getprop ro.boot.slot_suffix):41943040:9f1c78ff87e91b0741d64467ba7c51f66d461833 && \
      (log -t install_recovery "Installing new recovery image: succeeded" && setprop vendor.ota.recovery.status 200) || \
      (log -t install_recovery "Installing new recovery image: failed" && setprop vendor.ota.recovery.status 454)
else
  log -t install_recovery "Recovery image already installed" && setprop vendor.ota.recovery.status 200
fi

