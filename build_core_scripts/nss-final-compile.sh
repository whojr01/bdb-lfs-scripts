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
# Description: This script runs configure, builds, and installs nss
# Distribution: nss-3.35
# 

BUILD=nss
STAGE=2
PASS=1
SCRIPT=$0
TIMETMPFILE=/tmp/$$-tmp-build.dat

# Test Note:
# Note that you might have to add `nss.local` to `/etc/hosts` if it's not
# there. The entry should look something like `127.0.0.1 nss.local nss`.
#
# Inorder to get tests to run: create link in dist folder.
# lrwxrwxrwx 1 root root   40 Mar  7 20:22 Linux3.10_x86_cc_glibc_PTH_DBG.OBJ ->
#			 Linux3.10_x86_64_cc_glibc_PTH_64_OPT.OBJ
#


{
	time { 
		if [ $(basename $PWD) != "nss" ] && [ ! -d "nss" ]; then
			echo "Must bin root dir of nss-3.35"; exit 1;
		fi
		cd nss
		make -j1 BUILD_OPT=1				\
			NSPR_INCLUDE_DIR=/usr/include/nspr	\
			USE_SYSTEM_ZLIB=1			\
			ZLIB_LIBS=-lz				\
			NSS_ENABLE_WERROR=0			\
			$([ $(uname -m) = x86_64 ] && echo USE_64=1) \
			$([ -f /usr/include/sqlite3.h ] && echo NSS_USR_SYSTEM_SQLITE=1) > make.out 2>&1 \
		&& export HOST=nss DOMSUF=local \
		&& cd tests \
		&& ./all.sh > test.out 2>&1 \
		&& unset HOST DOMSUF	\
		&& cd ..	\
		&& cd ../dist	\
		&& install -v -m755 Linux*/lib/*.so              /usr/lib > install.out	2>&1 \
		&& install -v -m644 Linux*/lib/{*.chk,libcrmf.a} /usr/lib >> install.out 2>&1 \
		&& install -v -m755 -d                           /usr/include/nss >> install.out 2>&1 \
		&& cp -v -RL {public,private}/nss/*              /usr/include/nss >> install.out 2>&1 \
		&& chmod -v 644                                  /usr/include/nss/* >> install.out 2>&1 \
		&& install -v -m755 Linux*/bin/{certutil,nss-config,pk12util} /usr/bin >> install.out 2>&1 \
		&& install -v -m644 Linux*/lib/pkgconfig/nss.pc  /usr/lib/pkgconfig >> install.out 2>&1 
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

