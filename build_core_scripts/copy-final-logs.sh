#!/bin/bash

# This script copies the logs config.out, make.out and install.out to
# the $LFS/logs directory prefixed by value passed in and with date time
# appended to the filename.
#
#

setname()
{
	[[ -z $FileName ]] && return
	FileName="$PREFIX-$(echo $FileName | sed -e 's/\(.*\)\.out/\1/')-$DATESTAMP.out"
}


LOGDIR=/logs
PREFIX=$1-final
if [[ -z $PREFIX ]]; then
	echo "Usage: $0: LOG_PREFIX"
	exit 1
fi

DATESTAMP=$(date +%m%d%Y%H%M)

for SrcName in config.out config.log make.out test.out install.out patch.out
do
	if [[ -f $SrcName ]]; then
		FileName=$SrcName
		setname
		cp -v $SrcName $LOGDIR/$FileName
	else
		echo $SrcName not found
	fi
done

find /{bin,boot,etc,lib,lib64,opt,tools,usr,var} -print > $LOGDIR/stages/dirs_$PREFIX.txt 2>&1

