#!/bin/bash
#
# March 2018 xuzhenxing <xuzhenxing@canaan-creative.com>

# Mount img file
# Check offset value: fdisk -lu img-file
mount_img() {
    mkdir ./mount
    sudo mount -t auto -o loop,offset=$((94208*512)) ./2017-11-29-raspbian-stretch-lite.img ./mount
    sleep 1
}

# Git pyserial
git_pyserial() {
    cd ./mount/home/pi
    git clone https://github.com/XzxEmbedded/pyserial.git
    sleep 1
}

# Git miner-automate-test-scripts
git_scripts() {
    git clone https://github.com/XzxEmbedded/miner-automate-test-scripts.git
    sleep 1
}

# Umount img file
umount_img() {
    cd ../../../
    sudo umount ./mount
    rm -fr ./mount
}

for conf in "$@"
do
    case $conf in
        --mount)
            mount_img
            ;;
        --serial)
            git_pyserial
            ;;
        --scripts)
            git_scripts
            ;;
        --umount)
            umount_img
            ;;
        --all)
            mount_img && git_pyserial && git_scripts && umount_img
            ;;
        *)
            ;;
    esac
done
