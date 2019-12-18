#!/tools/bin/bash

#
# This script will create the directory structure used for LFS
# 

# DEBUG=/lfsbuild/lfs_scripts/foobar
DEBUG=

mkdir -pv $DEBUG/{bin,boot,etc/{opt,sysconfig},home,lib/firmware,mnt,opt}
mkdir -pv $DEBUG/{media/{floppy,cdrom},sbin,srv,var}
install -dv -m 0750 $DEBUG/root
install -dv -m 1777 $DEBUG/tmp $DEBUG/var/tmp
mkdir -pv $DEBUG/usr/{,local/}{bin,include,lib,sbin,src}
mkdir -pv $DEBUG/usr/{,local/}share/{color,dict,doc,info,locale,man}
mkdir -pv $DEBUG/usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -v $DEBUG/usr/libexec
mkdir -pv $DEBUG/usr/{,local/}share/man/man{1..8}

case $(uname -m) in
	x86_64) mkdir -v $DEBUG/lib64;;
esac

mkdir -v $DEBUG/var/{log,mail,spool}
ln -sv /run $DEBUG/var/run
ln -sv /run/lock $DEBUG/var/lock
mkdir -pv $DEBUG/var/{opt,cache,lib/{color,misc,locate},local}

