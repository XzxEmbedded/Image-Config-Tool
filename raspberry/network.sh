#!/bin/bash
#
# March 2018 xuzhenxing <xuzhenxing@canaan-creative.com>

interface=`cat /home/pi/network.conf | grep interface`
if [ "$?" -eq "0" ]; then
    sudo sed -i "39 a $interface" /etc/dhcpcd.conf
    ip=`cat /home/pi/network.conf | grep ip_address`
    sudo sed -i "40 a $ip" /etc/dhcpcd.conf
    router=`cat /home/pi/network.conf | grep routers`
    sudo sed -i "41 a $router" /etc/dhcpcd.conf
    dns=`cat /home/pi/network.conf | grep domain`
    sudo sed -i "42 a $dns" /etc/dhcpcd.conf
    rm /home/pi/network.conf

    sudo ifconfig eth0 down
    sleep 1
    sudo ifconfig eth0 up
fi
