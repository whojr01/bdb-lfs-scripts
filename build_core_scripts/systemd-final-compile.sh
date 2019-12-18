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
# Description: This script runs configure, builds, and installs systemd
# Distribution: systemd-236
# 

BUILD=systemd
STAGE=2
PASS=1
SCRIPT=$0
TIMETMPFILE=/tmp/$$-tmp-build.dat

{
	time { \
		LANG=en_US.UTF-8	\
		meson --prefix=/usr	\
			--sysconfdir=/etc	\
			--localstatedir=/var	\
			-Dacl=true		\
			-Dadm-group=true	\
			-Dbashcompleteiondir=/etc/bash_completeion.d	\
			-Dblacklight=true	\
			-Dblkid=true		\
			-Dbuildtype=release	\
			-Dbzip2=true		\
			-Dcoredump=true		\
			-Ddebug-shell=/bin/bash	\
			-Ddebug-tty=/dev/tty9	\
			-Dbus=true				\
			-Ddbuspolicydir=/usr/share/dbus-1	\
			-Dbussessionsservicedir=/usr/share/dbus-1/session.d	\
			-Dbussystemservicedir=/usr/share/dbus-1/services	\
			-Ddefault-dnssec=no          \
			-Ddefault-kill-user-processes=false	\
			-Defi=true				\
			-Delfutils=true				\
			-Denvironment-d=true			\
			-Dfirstboot=true			\
			-Dgcrypt=true				\
			-Dglib=true				\
			-Dgshadow=true				\
			-Dhostnamed=true			\
			-Dhtml=false				\
			-Dhwdb=true				\
			-Dimportd=auto				\
			-Dinstall-tests=false			\
			-Dkill-path=/bin/kill			\
			-Dkvm-mode=0666				\
			-Dman=true				\
			-Dkmod=true				\
			-Dkmod-path=/bin/kmod			\
			-Dldconfig=false             		\
			-Dlibcryptsetup=true			\
			-Dlibcurl=true				\
			-Dloadkeys-path=/usr/bin/loadkeys	\
			-Dlocaled=true				\
			-Dlogind=true				\
			-Dlz4=true				\
			-Dmachined=true				\
			-Dmount-path=/bin/mount      		\
			-Dnetworkd=true				\
			-Dnobody-group=nogroup			\
			-Dnobody-user=nobody			\
			-Dnss-systemd=true			\
			-Dpam=true				\
			-Dpamlibdir=/lib/security		\
			-Dpamconfdir=/etc/pam.d			\
			-Dpkgconfigdatadir=/usr/share/pkgconfig	\
			-Drandom-seed=true			\
			-Dresolve=true				\
			-Drfkill=true				\
			-Drootprefix=                		\
			-Drootlibdir=/lib            		\
			-Dsetfont-path=/usr/bin/setfont		\
			-Dslow-tests=true			\
			-Dsplit-usr=true             		\
			-Dsulogin-path=/sbin/sulogin 		\
			-Dsysusers=true             		\
			-Dsysvinit-path=/etc/init.d		\
			-Dsysvrcnd-path=/etc/rc.d		\
			-Dtests=true				\
			-Dtimedated=true			\
			-Dtimesynced=true			\
			-Dtmpfiles=true				\
			-Dtpm=true				\
			-Dtty-gid=5				\
			-Dumount-path=/bin/umount    		\
			-Dutmp=true				\
			-Dvconsole=true				\
			-Dwheel-group=true			\
			-Dxkbcommon=true			\
			-Dxz=true				\
			-Dzlib=true				\
			-Db_lto=false                		\
			.. > config.out 2>&1 			\
		&& LANG=en_US.UTF-8 ninja > make.out 2>&1 \
		&& LANG=en_US.UTF-8 ninja install > install.out 2>&1 ;
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

