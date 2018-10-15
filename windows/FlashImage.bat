@echo off




::路径注意增加\
@set flashpath=Z:\msm8909\out\target\product\msm8909\
@set Dynamic_library_Path=Z:\msm8909\out\target\product\msm8909\obj\lib\sensors.msm8909.so
@set Sensors_conf=Z:\DT380\LINUX\android\vendor\qcom\proprietary\sensors\dsps\reg_defaults\sensor_def_qcomdev.conf
@set boot_image=%flashpath%boot.img
@set mbn_image=%flashpath%emmc_appsboot.mbn
@set userdata_image=%flashpath%userdata.img
@set system_image=%flashpath%system.img
@set persist_image=%flashpath%persist.img
@set recover_image=%flashpath%recovery.img
@set cache_image=%flashpath%cache.img
@set Dynamic_library=%Dynamic_library_Path%
@set Dynamic_library_Board_Path=/system/lib/hw/

::初始化,下面便是判断是否有文件
@set Image_Index=0
@set Image_Current-path=0
@set Image_Length=7
@set Image[0]-path=%boot_image%
@set Image[1]-path=%mbn_image%
@set Image[2]-path=%system_image%
@set Image[3]-path=%persist_image%
@set Image[4]-path=%recover_image%
@set Image[5]-path=%cache_image%
@set Image[6]-path=%Dynamic_library%
::初始化

:LoopStart

::清空字符串
@set Image_Current-path=0

if %Image_Index% equ %Image_Length% goto BeginRun

for /f "usebackq tokens=1,2,3 delims==-" %%a in (`set Image[%Image_Index%]`) do (
    set Image_Current-%%b=%%c
)

if exist %Image_Current-path% (
	@echo 该路径%Image_Current-path%存在......
	@echo.
) else (
	@echo %Image_Current-path%
	@echo 请确定该文件文件是否存在？如果不存在，请确定路径，打开脚本重新设置。10秒后关闭....
	@ping -n 10 127.0.0.1>nul
	exit
)

@set /a Image_Index=%Image_Index%+1

goto LoopStart

:BeginRun
@echo 检查Android镜像文件已经完成，请继续下一步......
@echo.

@echo 0、同时烧录emmc_appsboot.mbn和boot.img
@echo 1、烧录boot.img
@echo 2、烧录aboot.img
@echo 3、烧录persist.img
@echo 4、烧录recovery.img
@echo 5、烧录system.img
@echo 6、烧录cache.img
@echo 7、烧录所有镜像
@echo 8、重新推进sensor.so
::@echo 10、烧录并更新adsp架构下的sensor文件

@set /p option=请先设置路径后，再输入要烧录的选项：


if "%option%" == "9" (
adb root
adb wait-for-device
adb remount
@echo 重新推进sensor........
adb push %Dynamic_library% %Dynamic_library_Board_Path%
adb reboot
@echo 正在重启...... 2秒后关闭....
@ping -n 2 127.0.0.1>nul

exit
)


::判断是否进入fastboot模式
fastboot devices>1.txt
set /p message=<1.txt
del 1.txt
if not defined message (
    echo 正处于adb mode模式.....
	adb wait-for-device
	adb reboot-bootloader
) else ( 
	echo 正处于fastboot mode模式.....
)


@echo.

if "%option%" == "0" (
@echo 同时烧录emmc_appsboot.mbn和boot.img........
fastboot flash boot %boot_image%
fastboot flash aboot %mbn_image%
)

if "%option%" == "1" (
@echo 烧录boot.img........
fastboot flash boot %boot_image%
)

if "%option%" == "2" (
@echo 烧录aboot.img........
fastboot flash aboot %mbn_image%
)

if "%option%" == "3" (
@echo 烧录persist.img..........
fastboot flash persist %persist_image%
)

if "%option%" == "4" (
@echo 烧录recovery.img...........
fastboot flash recovery %recover_image%
)

if "%option%" == "5" (
@echo 烧录system.img........
fastboot flash system %system_image%
)

if "%option%" == "6" (
@echo 烧录cache.img...........
fastboot flash cache %cache_image%
)

if "%option%" == "7" (
@echo 烧录所有镜像.............
fastboot flash boot %boot_image%
fastboot flash aboot %mbn_image%
fastboot flash persist %persist_image%
fastboot flash ramdisk %ramdisk_image%
fastboot flash recovery %recover_image%
fastboot flash system %system_image%
fastboot flash cache %cache_image%
fastboot flash userdata %userdata_image%
)




fastboot reboot
@echo 正在重启 请稍后......
@echo 是否抓取kernel log？
@set /p option_log=请选择:


if "%option_log%" == "Y" (
@echo 正在抓取kernel log...........

adb wait-for-device && adb root
adb wait-for-device && adb remount


@ping -n 2 127.0.0.1>nul
adb shell dmesg > kmesg.log
@echo kernel log已经导出.....
)

if "%option_log%" == "y" (
@echo 正在抓取kernel log...........

adb wait-for-device && adb root
adb wait-for-device && adb remount


@ping -n 2 127.0.0.1>nul
adb shell dmesg > kmesg.log
@echo kernel log已经导出.....
)
@echo [烧录成功，暂停2秒自动关闭]
@ping -n 2 127.0.0.1>nul

