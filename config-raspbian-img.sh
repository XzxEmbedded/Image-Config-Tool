#!/bin/bash
#
# March 2018 xuzhenxing <xuzhenxing@canaan-creative.com>

# Mount img file
# Check offset value: fdisk -lu img-file
mkdir ./mount
sudo mount -t auto -o loop,offset=$((94208*512)) ./2017-11-29-raspbian-stretch-lite.img ./mount
sleep 1

# Git pyserial
cd ./mount/home/pi
git clone https://github.com/XzxEmbedded/pyserial.git
sleep 1

# Git miner-automate-test-scripts
git clone https://github.com/XzxEmbedded/miner-automate-test-scripts.git
sleep 1

# Umount img file
cd ../../../
sudo umount ./mount
rm -fr ./mount
