#!/usr/bin/dash -e

# Copyright (c) 2019-2020, Firas Khalil Khana
# Distributed under the terms of the ISC License

NAME=glaucus.img &&
SIZE=2G &&
LOOP=$(losetup -f) &&

MKDIR='/usr/bin/install -dv' &&
RM='/usr/bin/rm -frv' &&
RSYNC='/usr/bin/rsync -vaHAXx' &&

cd /home/glaucus &&

qemu-img create -f raw $NAME $SIZE &&
dd if=scripts/other/mbr.bin of=glaucus.img conv=notrunc bs=440 count=1 &&

parted -s $NAME mklabel msdos &&
parted -s -a none $NAME mkpart primary ext4 0 $SIZE &&
parted -s -a none $NAME set 1 boot on &&

losetup -D &&
losetup $LOOP $NAME &&

partx -a $LOOP &&
mkfs.ext4 $(printf $LOOP)p1 &&

mount $(printf $LOOP)p1 /mnt/loop &&

$RM /mnt/loop/lost+found &&

$MKDIR /mnt/loop/dev &&
$MKDIR /mnt/loop/proc &&
$MKDIR /mnt/loop/run &&
$MKDIR /mnt/loop/sys &&

$RSYNC boot /mnt/loop --delete &&
$RSYNC etc /mnt/loop &&
$RSYNC root /mnt/loop &&
$RSYNC usr /mnt/loop &&
$RSYNC var /mnt/loop &&

$MKDIR /mnt/loop/boot/extlinux &&
$RSYNC scripts/other/extlinux.conf /mnt/loop/boot/extlinux &&
extlinux --install /mnt/loop/boot/extlinux &&

umount /mnt/loop &&
partx -d $LOOP &&
losetup -d $LOOP
