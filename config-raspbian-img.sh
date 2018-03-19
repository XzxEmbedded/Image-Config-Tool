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

# Git pyserial and auto test scripts
git_pyserial_scripts() {
    cd ./mount/home/pi
    git clone https://github.com/XzxEmbedded/pyserial.git
    sleep 1
    git clone https://github.com/XzxEmbedded/miner-automate-test-scripts.git
    cd ../../../
    sleep 1
}

# Network config
network_config() {
    sudo chmod 777 ./mount/etc/dhcpcd.conf
    cat network.conf | grep interface >> ./mount/etc/dhcpcd.conf
    cat network.conf | grep ip_address >> ./mount/etc/dhcpcd.conf
    sudo chmod 664 ./mount/etc/dhcpcd.conf
}

# Umount img file
umount_img() {
    sudo umount ./mount
    rm -fr ./mount
}

for conf in "$@"
do
    case $conf in
        --mount)
            mount_img
            ;;
        --git)
            git_pyserial_scripts
            ;;
        --network)
            network_config
            ;;
        --umount)
            umount_img
            ;;
        --all)
            mount_img && git_pyserial_scripts && network_config && umount_img
            ;;
        *)
            ;;
    esac
done
