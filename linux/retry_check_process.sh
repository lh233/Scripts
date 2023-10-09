#!/bin/bash
node_name="nhpdGraph"
i=0
while true;
do
    adb -d wait-for-devices
    cpu_loading_f=$(adb -d  shell top -b -n 1  | grep  "nhpdGraph" | awk '{print $6}')
    cpu_loading=$( printf "%.0f" "$cpu_loading_f")
    echo "cpu_loading is " $cpu_loading $cpu_loading_f
    if [ $cpu_loading -gt 10 ]; then
        echo "CPU loading of $node_name is above 10%, exiting..." 
        let "i=i+1"
        echo "success reboot for ar9341 " $i 
        adb -d  shell reboot
        #$cpu_loading=0
        sleep 50
    else
        echo "CPU loading of $node_name is $cpu_loading%, continuing..."
        sleep 1
    fi
done
