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
    git clone https://github.com/XzxEmbedded/miner-automate-test-scripts.git
    cd ../../../
    sleep 1
}

# Start ssh
ssh_start() {
    sudo sed -i '19 a \\t' ./mount/etc/rc.local
    sudo sed -i '19 a sudo /etc/init.d/ssh start' ./mount/etc/rc.local
    sleep 1
}

# Install expect
install_expect() {
    sudo sed -i '21 a \\t' ./mount/etc/rc.local
    sudo sed -i '21 a sudo apt-get install expect -y' ./mount/etc/rc.local
    sleep 1
}

# Install pyserial
install_pyserial() {
    sudo sed -i '23 a \\t' ./mount/etc/rc.local
    dir="cd /home/pi/pyserial"
    sudo sed -i "23 a $dir" ./mount/etc/rc.local
    sudo sed -i '24 a sudo python setup.py install' ./mount/etc/rc.local
    sleep 1
}

# Config ssh_config
ssh_config() {
    sudo sed -i '35 a StrictHostKeyChecking no' ./mount/etc/ssh/ssh_config
    sleep 1
}

# Network config
network_config() {
    cp ./network.conf ./mount/home/pi
    cp ./network.sh ./mount/home/pi
    sudo sed -i '26 a \\t' ./mount/etc/rc.local
    sudo sed -i '26 a sh /home/pi/network.sh' ./mount/etc/rc.local
    sleep 1
}

# Umount img file
umount_img() {
    sudo umount ./mount
    rm -fr ./mount
}

# Help
show_help() {
    echo "\
    --mount         Mount img file
    --git           After img file, git clone pyserial and auto test scripts
    --ssh           After img file, setting ssh
    --expect        After img file, install expect
    --pyserial      After img file, install pyserial
    --hostkey       After img file, setting ssh_config
    --network       After img file, setting network
    --umount        Umount img file
    --all           Run all steps
    --help          Display help message
    "
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
        --ssh)
            start_ssh
            ;;
        --expect)
            install_expect
            ;;
        --pyserial)
            install_pyserial
            ;;
        --hostkey)
            ssh_config
            ;;
        --network)
            network_config
            ;;
        --umount)
            umount_img
            ;;
        --all)
            mount_img && git_pyserial_scripts && ssh_start && install_expect && install_pyserial &&
            ssh_config && network_config && umount_img
            ;;
        --help)
            show_help
            ;;
        *)
            show_help
            ;;
    esac
done
