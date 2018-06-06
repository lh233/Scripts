@echo off  
set var=0
:continue  
echo excute %var% times
adb shell input keyevent 26
@ping -n 3 127.0.0.1>nul
set /a var+=1  
if %var% lss 50 goto continue   
pause