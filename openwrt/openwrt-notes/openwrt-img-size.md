# Changing Openwrt img size

	(1) make menuconfig

	(2) Target Images ---> Boot (SD Card) filesystem partition size (in MB)/Root filesystem partition size (in MB) ---> modify size

	(3) make -j13 world
