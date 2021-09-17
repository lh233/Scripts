#!/bin/sh
echo "======start reboot ======"
for((i=1;i<=100;i++));  
do   
adb wait-for-device
adb reboot
echo "reboot" $i
done 
