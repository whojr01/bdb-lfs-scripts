#!/bin/bash

# This script searches the stage log files for the first occurance of the
# specified file.
#

LOOKINGFOR=$1
[[ -d /lfs  ]] && LFSBUILD=/lfsbuild
CP5_STAGE_LOGS=$LFSBUILD/data-files/chp5_logs/stages
CP6_STAGE_LOGS=$LFSBUILD/logs/stages

[[ ! -d $CP5_STAGE_LOGS ]] && LOOKINGFOR= && echo "Error: Can't access directory $CP5_STAGE_LOGS"
[[ ! -d $CP6_STAGE_LOGS ]] && LOOKINGFOR= && echo "Error: Can't access directory $CP6_STAGE_LOGS"

if [[ -z $LOOKINGFOR ]] ; then
	cat << EOF
Usage:
	$0: filename
	where:
		filename - is just the filename. No Path - Just filename.

EOF
exit 1
fi

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

