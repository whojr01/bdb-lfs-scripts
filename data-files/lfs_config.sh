#
# lfs_config.sh
# This file defines the variables used in build and utility scripts.
# A change here affects all the scripts that include it.
#

# To use this file simply include the libe below after the sha-bang
# but before the start of the script. Cut and paste the line into your
# script and adjust the path to locate this file correctly. 
# . /lfsbuild/data_files/lfs_config.sh || { echo "Failed to find variables. Aborting" && exit 1; }

# Location of the partition where the tools directory is located.
LFSDRIVE=${LFSDRIVE-/lfsbuild}

# Location where to save the build logs and timing data.
LOGDIR=$LFSDRIVE/logs

# Location where to save the timing data.
TIMEDATADIR=$LFSDRIVE/logs/timedata

# Absolute path and filename to store the timing data.
TIMEDATALOG=$TIMEDATADIR/buildtimelog.txt

# Location where to store the generic build flags
BUILDGENERIC=$LFSDRIVE/logs/generic

# Absolute path and filename to generic log directory
BUILDGENERICLOG=$BUILDGENERIC/genericbuildcmds.txt

# Tempary file used to format time data.
TIMETMPFILE=/tmp/$$-tmp-build.dat

if [ ! -d "$LOGDIR" ]
then
	mkdir -p $LOGDIR
	if [ $? -ne 0 ]
	then
		echo "[$0]: Error: Can't create log dir. Aborting... "
		exit 1;
	fi
fi

if [ ! -d "$TIMEDATADIR" ]
then
        mkdir -p $TIMEDATADIR
        if [ $? -ne 0 ]
        then
                echo "[$0]: Error: Can't create time log dir. Aborting... "
                exit 1;
        fi
fi

if [ ! -d "$BUILDGENERIC" ]
then
	mkdir -p $BUILDGENERIC
	if [ $? -ne 0 ]
	then
		echo "[$0]: Error: Can't create generic log dir. Aborting..."
		exit 1;
	fi
fi

