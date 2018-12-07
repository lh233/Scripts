@echo off  
set var=0
:continue  
echo excute %var% times
adb reboot
@ping -n 60 127.0.0.1>nul
adb shell ping -c 1 www.baidu.com | findstr /i "TTL" >NUL 2>NUL && goto yes
echo "ping failed"
pause
:yes
echo "ping success"
set /a var+=1  
if %var% lss 5000 goto continue   