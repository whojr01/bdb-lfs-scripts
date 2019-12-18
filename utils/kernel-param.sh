#!/bin/bash

# This script displays the kernel options for the HOST and LFS system.
#

LOOKINGFOR=$1

[[ -d /lfs ]] && LFSBUILD=/lfsbuild
KernelHostConfig=$LFSBUILD/data-files/KernelHostConfig
LFSHostConfig=$LFSBUILD/data-files/LFSHostConfig

[[ ! -f $KernelHostConfig ]] && echo "Error: Can't access Kernel file [$KernelHostConfig]"
[[ ! -f $LFSHostConfig ]] && echo "Error: Can't access Kernel file [$LFSHostConfig]"


fnd=
echo "Searching: $CP5_STAGE_LOGS"
for i in $(ls -1tr $CP5_STAGE_LOGS)
do
	[[ "x$(grep $LOOKINGFOR $CP5_STAGE_LOGS/$i)" != "x" ]] && echo "	Found in: $CP5_STAGE_LOGS/$i" && fnd=1 && break
done

[[ -z $fnd ]] && echo "Not found in $CP5_STAGE_LOGS"

fnd=
echo
echo "Searching: $CP6_STAGE_LOGS"
for i in $(ls -1tr $CP6_STAGE_LOGS)
do
	[[ "x$(grep $LOOKINGFOR $CP6_STAGE_LOGS/$i)" != "x" ]] && echo "	Found in: $CP6_STAGE_LOGS/$i" && fnd=1 && break
done

[[ -z $fnd ]] && echo "Not found in $CP6_STAGE_LOGS"

echo

