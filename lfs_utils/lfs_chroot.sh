#!/bin/bash

# This script performs the chroot required to build LFS. It mounts the required
# device mounts and then issues the chroot command.
#
#

umount $LFS/dev 2> /dev/null
umount $LFS/proc 2> /dev/null
umount $LFS/sys 2> /dev/null
umount $LFS/run 2> /dev/null

#
# A bind mount is a special mount that allows you
# to create a mirror of a directory or mount point
# to some other location.
#
mount -v --bind /dev $LFS/dev || exit 1

mount -vt devpts devpts $LFS/dev/pts -o gid=5,mode=620
mount -vt proc proc $LFS/proc || exit 1
mount -vt sysfs sysfs $LFS/sys || exit 1
mount -vt tmpfs tmpfs $LFS/run || exit 1

if [ -h $LFS/dev/shm ]; then
	mkdir -pv $LFS/$(readlink $LFS/dev/shm)
fi

chroot "$LFS" /tools/bin/env -i \
	HOME=/root		\
	TERM="$TERM"		\
	PS1='(lfs chroot) \u:\w\$ '	\
	PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin	\
	/tools/bin/bash --login +h

