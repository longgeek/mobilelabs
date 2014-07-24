#!/bin/bash

cd /usr/local/src/
tar jxf linux-2.6.32-431.el6.tar.bz2 -C /usr/src/kernels/
cd /usr/src/kernels
mv $(uname -r) $(uname -r)-old
mv linux-2.6.32-431.el6 $(uname -r)
cd $(uname -r)
make mrproper
cp ../$(uname -r)-old/Module.symvers .
cp /boot/config-$(uname -r) ./.config
make oldconfig
make prepare
make scripts
make CONFIG_BLK_DEV_NBD=m M=drivers/block
cp drivers/block/nbd.ko /lib/modules/$(uname -r)/kernel/drivers/block/
depmod -a
modprobe nbd
