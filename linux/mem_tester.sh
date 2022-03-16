#!/bin/bash
#老化脚本,可以定时停止任务
LOG_DIR="/userdata/logs/product_test/ageing/"
arr=(
    8kb
    80kb
    800kb
    8mbl
    80mb
)

timeout()
{
        waitfor=$2

        command=$1
        $command &
        #$!表示Shell最后运行的后台Process的PID
        commandpid=$!

        ( sleep $waitfor ; kill -9 $commandpid > /dev/null 2>&1 ) &

        watchdog=$!
        sleeppid=$PPID

        wait $commandpid > /dev/null 2>&1

        kill $sleeppid > /dev/null 2>&1
        
        #确保进程被干掉
        kill -9 `pidof memtester`
}

testmem()
{
    rm -rf ${LOG_DIR}memtester.txt
    while(true)
    do
        for i in "${arr[@]}";
        do
            /usr/sbin/memtester $i 1 >> ${LOG_DIR}memtester.txt
            echo "$i" >> ${LOG_DIR}memtester.txt
            echo "$1" >> ${LOG_DIR}memtester.txt
            date +%T >> ${LOG_DIR}memtester.txt
        done
    done
}



source /opt/ros/kinetic/setup.sh
if [ ! -d "${LOG_DIR}" ]; then
   mkdir ${LOG_DIR}
fi


timeout testmem $1

