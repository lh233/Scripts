@echo off




::·��ע������\
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

::��ʼ��,��������ж��Ƿ����ļ�
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
::��ʼ��

:LoopStart

::����ַ���
@set Image_Current-path=0

if %Image_Index% equ %Image_Length% goto BeginRun

for /f "usebackq tokens=1,2,3 delims==-" %%a in (`set Image[%Image_Index%]`) do (
    set Image_Current-%%b=%%c
)

if exist %Image_Current-path% (
	@echo ��·��%Image_Current-path%����......
	@echo.
) else (
	@echo %Image_Current-path%
	@echo ��ȷ�����ļ��ļ��Ƿ���ڣ���������ڣ���ȷ��·�����򿪽ű��������á�10���ر�....
	@ping -n 10 127.0.0.1>nul
	exit
)

@set /a Image_Index=%Image_Index%+1

goto LoopStart

:BeginRun
@echo ���Android�����ļ��Ѿ���ɣ��������һ��......
@echo.

@echo 0��ͬʱ��¼emmc_appsboot.mbn��boot.img
@echo 1����¼boot.img
@echo 2����¼aboot.img
@echo 3����¼persist.img
@echo 4����¼recovery.img
@echo 5����¼system.img
@echo 6����¼cache.img
@echo 7����¼���о���
@echo 8�������ƽ�sensor.so
::@echo 10����¼������adsp�ܹ��µ�sensor�ļ�

@set /p option=��������·����������Ҫ��¼��ѡ�


if "%option%" == "9" (
adb root
adb wait-for-device
adb remount
@echo �����ƽ�sensor........
adb push %Dynamic_library% %Dynamic_library_Board_Path%
adb reboot
@echo ��������...... 2���ر�....
@ping -n 2 127.0.0.1>nul

exit
)


::�ж��Ƿ����fastbootģʽ
fastboot devices>1.txt
set /p message=<1.txt
del 1.txt
if not defined message (
    echo ������adb modeģʽ.....
	adb wait-for-device
	adb reboot-bootloader
) else ( 
	echo ������fastboot modeģʽ.....
)


@echo.

if "%option%" == "0" (
@echo ͬʱ��¼emmc_appsboot.mbn��boot.img........
fastboot flash boot %boot_image%
fastboot flash aboot %mbn_image%
)

if "%option%" == "1" (
@echo ��¼boot.img........
fastboot flash boot %boot_image%
)

if "%option%" == "2" (
@echo ��¼aboot.img........
fastboot flash aboot %mbn_image%
)

if "%option%" == "3" (
@echo ��¼persist.img..........
fastboot flash persist %persist_image%
)

if "%option%" == "4" (
@echo ��¼recovery.img...........
fastboot flash recovery %recover_image%
)

if "%option%" == "5" (
@echo ��¼system.img........
fastboot flash system %system_image%
)

if "%option%" == "6" (
@echo ��¼cache.img...........
fastboot flash cache %cache_image%
)

if "%option%" == "7" (
@echo ��¼���о���.............
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
@echo �������� ���Ժ�......
@echo �Ƿ�ץȡkernel log��
@set /p option_log=��ѡ��:


if "%option_log%" == "Y" (
@echo ����ץȡkernel log...........

adb wait-for-device && adb root
adb wait-for-device && adb remount


@ping -n 2 127.0.0.1>nul
adb shell dmesg > kmesg.log
@echo kernel log�Ѿ�����.....
)

if "%option_log%" == "y" (
@echo ����ץȡkernel log...........

adb wait-for-device && adb root
adb wait-for-device && adb remount


@ping -n 2 127.0.0.1>nul
adb shell dmesg > kmesg.log
@echo kernel log�Ѿ�����.....
)
@echo [��¼�ɹ�����ͣ2���Զ��ر�]
@ping -n 2 127.0.0.1>nul

