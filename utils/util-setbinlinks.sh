#!/bin/bash

# This script links the instantiated programs to their corresponding
# target prefixed program. (e.g gcc -> x86_64-lfs-linux-gnu-gcc).
# 
# utilsetbinlinks {binutil | gcc} [target]
# where:
#	binutils - Set links for binutils
#	gcc - set links for gcc
#	target - Specify the host-target binaries to link to. (e.g. x86_64-lfs-linux-gnu)
#
# Parameters are position sensitive.
#

Usage()
{
	echo "Usage $0: { binutil | gcc } [target]"
	echo "Where:"
	echo "	binutil - Set links for binutil programs."
	echo "	gcc     - Set links for gcc programs."
	exit 1
}


[[ -z $1 ]] && Usage
[[ $1 != "binutil" && $1 != "gcc" ]] && Usage

BINUTILS="size objdump ar strings ranlib objcopy addr2line readelf elfedit nm strip c++filt as gprof ld.bfd ld"
GCCUTILS="c++ cpp g++ gcc gcc-ar gcc-nm gcc-ranlib gcov"

if [[ $1 == "binutil" ]] ; then
	UTIL=$BINUTILS
else
	UTIL=$GCCUTILS
fi

BINDIR=/tools/bin
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
DIRSTAMP="backup"
TARGET=${2-"x86_64-lfs-linux-gnu"}
BCKDIR="${BINDIR}/${DIRSTAMP}-${TIMESTAMP}"
x=0

if [ ! -d "$BINDIR/$BCKDIR" ] ; then
	mkdir $BCKDIR
	[ $? -ne 0 ] && echo "Error: Can't create backup dir... aborting" && exit 1
fi

for i in $UTIL
do
	if [ -h "$BINDIR/$i" ]
	then
		# If a link is set then bark and skip it.
		echo "Not processing link $BINDIR/$i"
		continue
	fi

	if [ -f "$BINDIR/$i" ] ; then
		[ -f "$BINDIR/$TARGET-$i" ] && mv -v $BINDIR/$TARGET-$i $BCKDIR
		cp -v $BINDIR/$i "$BINDIR/$TARGET-$i"
		mv -v $BINDIR/$i $BCKDIR
		chmod +x "$BINDIR/$TARGET-$i"
		rm -fv $BINDIR/$i
		x=1
	fi
	[ -f "$BINDIR/$TARGET-$i" ] && ln -sv "$TARGET-$i" $BINDIR/$i && x=1
done

[ $x -eq 0 ] && rmdir $BCKDIR && echo -n "Not "
echo "updated."
