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
# Description: This script runs configure, builds, and installs xorg-apps
# Distribution: xorg_apps
# 

BUILD=xorg_apps
STAGE=2
PASS=1
SCRIPT=$0
TIMETMPFILE=/tmp/$$-tmp-build.dat

if [ ! -f ../app-7.md5 ]; then
	echo "Environment is not properly configured. See:"
	echo "http://www.linuxfromscratch.org/blfs/view/svn/x/x7app.html"
	exit 1
fi

{
	time { \
		for package in $(grep -v '^#' ../app-7.md5 | awk '{print $2}')
		do
			echo "###############################" 2>&1 | tee -a config.out combined.out > /dev/null 2>&1
			echo "# Tar $package #" 2>&1 | tee -a config.out combined.out > /dev/null 2>&1
			echo "###############################" 2>&1 | tee -a config.out combined.out > /dev/null 2>&1
			packagedir=${package%.tar.bz2}
			tar -xvf $package 2>&1 | tee -a config.out combined.out > /dev/null 2>&1
			if [ $? -ne 0 ]; then
				echo "**** Tar Failure: $package" 2>&1 | tee -a config.out combined.out > /dev/null 2>&1
				echo "tar: $package" 2>&1 | tee -a failure.out combined.out > /dev/null 2>&1
				continue
			fi

			pushd $packagedir
				case $packagedir in
					lutil-[0-9]* )
						line1="#ifdef _XOPEN_SOURCE"
						line2="#  undef _XOPEN_SOURCE"
						line3="#  define _XOPEN_SOURCE 600"
						line4="#endif"

						sed -i -e "s@#ifdef HAVE_CONFIG_H@$line1\n$line2\n$line3\n$line4\n\n&@" sys.c
						unset line1 line2 line3 line4
					;;

					sessreg-* )
						sed -e 's/\$(CPP) \$(DEFS)/$(CPP) -P $(DEFS)/' -i man/Makeifle.in
					;;
				esac

				echo "###############################" 2>&1 | tee -a config.out ../combined.out > /dev/null 2>&1
				echo "# Config $package #" 2>&1 | tee -a config.out ../combined.out > /dev/null 2>&1
				echo "###############################" 2>&1 | tee -a config.out ../combined.out > /dev/null 2>&1
				./configure $XORG_CONFIG 2>&1 | tee -a config.out ../combined.out > /dev/null 2>&1
				if [ $? -ne 0 ] ; then
					echo "**** Configure failure: $package" 2>&1 | tee -a config.out ../combined.out > /dev/null 2>&1
					echo "configure: $package" 2>&1 | tee -a ../failure.out ../combined.out > /dev/null 2>&1
					continue
				fi

				echo "###############################" 2>&1 | tee -a make.out ../combined.out > /dev/null 2>&1
				echo "# Make $package #" 2>&1 | tee -a make.out ../combined.out > /dev/null 2>&1
				echo "###############################" 2>&1 | tee -a make.out ../combined.out > /dev/null 2>&1
				make 2>&1 | tee -a make.out ../combined.out > /dev/null 2>&1
				if [ $? -ne 0 ] ; then
					echo "**** Make failure: $package" 2>&1 | tee -a make.out ../combined.out > /dev/null 2>&1
					echo "make: $package" 2>&1 | tee -a ../failure.out ../combined.out > /dev/null 2>&1
					continue
				fi

				echo "###############################" 2>&1 | tee -a test.out ../combined.out > /dev/null 2>&1
				echo "# Test $package #" 2>&1 | tee -a ../test.out ../combined.out > /dev/null 2>&1
				echo "###############################" 2>&1 | tee -a test.out ../combined.out > /dev/null 2>&1
				make check 2>&1 | tee -a test.out ../combined.out > /dev/null 2>&1
				if [ $? -ne 0 ] ; then
					echo "**** Test failure: $package" 2>&1 | tee -a ../test.out ../combined.out > /dev/null 2>&1
					echo "test: $package" 2>&1 | tee -a ../failure.out ../combined.out > /dev/null 2>&1
				fi


				echo "###############################" 2>&1 | tee -a install.out ../combined.out > /dev/null 2>&1
				echo "# Install $package #" 2>&1 | tee -a install.out ../combined.out > /dev/null 2>&1
				echo "###############################" 2>&1 | tee -a install.out ../combined.out > /dev/null 2>&1
				make install 2>&1 | tee -a install.out ../combined.out > /dev/null 2>&1
				if [ $? -ne 0 ]; then
					echo "**** Install Failure: $package" 2>&1 | tee -a install.out ../combined.out > /dev/null 2>&1
					echo "install: $package" 2>&1 | tee -a ../failure.out ../combined.out > /dev/null 2>&1
					continue
				fi
				/lfs_scripts/copy-final-logs.sh ${packagedir-*}
			popd
#			rm -rf $packagedir
			echo "###############################" 2>&1 | tee -a install.out combined.out > /dev/null 2>&1
			echo "# Running /sbin/ldconfig      #" 2>&1 | tee -a install.out combined.out > /dev/null 2>&1
			echo "###############################" 2>&1 | tee -a install.out combined.out > /dev/null 2>&1
			/sbin/ldconfig --verbose 2>&1 | tee -a install.out combined.out > /dev/null 2>&1
		done
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

