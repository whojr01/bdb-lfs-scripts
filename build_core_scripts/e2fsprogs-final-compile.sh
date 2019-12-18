#!/bin/bash

# If not FINAL (ch6) builds then remove [FINAL=] below. Never set a value to [FINAL]
FINAL=

LFSDRIVE=${FINAL-/lfsbuild}
# load the lfs environment variables script.
. $LFSDRIVE/data-files/lfs_config.sh || { echo "Failed to find variables. Aborting" && exit 1; }


# The time data collected by this script is high-level in nature
# and does not record detailed information on the various steps
# of each build. 
#
# This limits the usefulness of the system down to just a general
# indicator of how much time a complete build will take on your
# system.
#
# Further the script utilizes the builtin time function in order
# to record how long it takes to execute the build so there is a
# fair margin of error in the actual reporting of the time. This
# timing function is just mearly to give an approximation of how
# long something takes and for that it's good enough and belongs
# in the Good Enough Inc company. ;-)
#
# Variables:
# BUILD - Contains the name of the build.
# STAGE - Contains which stage (Chapter 5/6)
# PASS  - Should be set to 1 or 2. (e.g bunutils, gcc.. etc)
# SCRIPT - Records the name of the build script.
# TIMETMPFILE - Used in the generation of time data. No need to change.
#
# Script:
# Description: This script runs configure, builds, and installs e2fsprogs
# Distribution: e2fsprogs-1.43.8
# 

BUILD=e2fsprogs
STAGE=2
PASS=1
SCRIPT=$0
TIMETMPFILE=/tmp/$$-tmp-build.dat

{
	time { \
		LIBS=-L/tools/lib	\
		CFLAGS=-I/tools/include	\
		PKG_CONFIG_PATH=/tools/lib/pkgconfig	\
		../configure --prefix=/usr	\
			--bindir=/bin		\
			--with-root-prefix=""	\
			--enable-elf-shlibs	\
			--disable-libblkid	\
			--disable-libuuid	\
			--disable-fsck > config.out 2>&1 \
		&& make > make.out 2>&1 \
		&& ln -svf /tools/lib/lib{blk,uu}id.so.1 lib \
		&& make LD_LIBRARY_PATH=/tools/lib check > test.out 2>&1 \
		&& make install > install.out 2>&1 \
		&& make install-libs >> install.out 2>&1 \
		&& chmod -v u+w /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a >> install.out 2>&1 \
		&& gunzip -v /usr/share/info/libext2fs.info.gz >> install.out 2>&1 \
		&& install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info >> install.out 2>&1 \
		&& makeinfo -o doc/com_err.info ../lib/et/com_err.texinfo >> install.out 2>&1 \
		&& install -v -m644 doc/com_err.info /usr/share/info >> install.out 2>&1 \
		&& install-info --dir-file=/usr/share/info/dir /usr/share/info/com_err.info >> install.out ;
	}
} 2> $TIMETMPFILE

#
# Default the time related data in case we don't care to fill it in.
#

PASS=${PASS:=1}
STAGE=${STAGE:=1}
BUILD=${BUILD:="unknown"}

echo "$BUILD,$STAGE,$PASS,$(basename $SCRIPT),$(cat $TIMETMPFILE | xargs -r | sed -e 's/[ ]*real[ ]*//' -e 's/[ ]*user[ ]*/,/' -e 's/[ ]*sys[ ]*/,/')" >> $TIMEDATALOG

rm -f $TIMETMPFILE

