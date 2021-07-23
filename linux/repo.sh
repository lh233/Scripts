#!/bin/sh
echo "======start repo sync======"
repo sync -j8
 
while [ $? = 1 ]; do
        echo "======sync failed, re-sync again======"
        sleep 3
        repo sync -j8
done
