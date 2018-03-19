@echo on
adb root
adb wait-for-device
adb remount
adb shell rm /system/etc/sensors/sensor_def_qcomdev.conf
adb push Z:/DT380/LINUX/android/vendor/qcom/proprietary/sensors/dsps/reg_defaults/sensor_def_qcomdev.conf /system/etc/sensors/sensor_def_qcomdev.conf
adb shell chmod 644 /system/etc/sensors/sensor_def_qcomdev.conf
adb shell rm /persist/sensors/sns.reg
adb shell sync
adb reboot