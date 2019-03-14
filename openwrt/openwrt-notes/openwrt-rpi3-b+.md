# OpenWrt Raspbian pi3 b+

## Debuging OpenWrt image for Raspbian pi3 b+

	Using OpenWrt the lastest codes, it can not support Raspbian pi3 b+.
	We need download bootcode.bin and start.elf from https://github.com/raspberrypi/firmware,
	then coping bootcode.bin and start.elf to openwrt-brcm2708-bcm2710-rpi-3-ext4-sysupgrade.img/lib/firmwarm/brcm

## Configuration kernel

	make kernel_menuconfig

## OpenWrt Forum

	https://forum.archive.openwrt.org/viewtopic.php?id=73564
