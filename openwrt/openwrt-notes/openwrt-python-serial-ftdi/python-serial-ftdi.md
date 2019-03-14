# Support python2/3 on OpenWrt system

## download openwrt source code
git clone https://github.com/openwrt/openwrt.git

## modify feeds.config.default or feeds.config file:
	src-git packages https://github.com/openwrt/packages.git
	or
	more other packages

## update and install packages:
	./script/feeds update -a
	./script/feeds install -a

## select config:
	make menuconfig

	(1) Lanuages --- lua/perl/python --- select python --- select python-pyserial

	(2)
	Kernel Modules --- USB Support --- kmod-usb-serial --- kmod-usb-serial-ftdi
	Kernel Modules --- USB Support --- kmod-usb-serial --- kmod-usb2/3

## build
	make -j13 world

## default network dhcp
	modify ip address for static ip
