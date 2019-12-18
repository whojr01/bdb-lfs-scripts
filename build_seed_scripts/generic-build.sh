#!/bin/bash

# load the lfs environment variables script.
. /lfsbuild/data-files/lfs_config.sh || { echo "Failed to find variables. Aborting" && exit 1; }

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

# This script runs configure in the current directory or
# if provided in the directory passed into the script. Then it 
# runs make and make install automatically assuming the Makefile
# is created in the current directory. The output from each
# command is redirected to config.out, make.out, and install.out
# respectively.
#
# The script outpus only the timing information to the terminal.
#
# If a second argument is passed to the script then the script
# will only execute the configure and build. It will not run test.
#

######################
# Redirect Variables #
######################

CONFOUT="config.out"
MAKEOUT="make.out"
TESTOUT="test.out"
INSTOUT="install.out"

Usage()
{
	echo "Usage: $0: [FLAGS]"
		   cat << EOF
	FLAGS (One or more)
	-b [Name] - Specifies the build name. (e.g. binutils)
	-c - Run $CONFDEF {directory}/configure --prefix=$LFS_TOOLS
	-C - Define $CONDEF variables on command line to configure. e.g. FOO= ./configure
	-d - Define directory location of configure. Default ".".
	-h - Help. This output
	-i - Run make install > install.out 2>&1
	-m - Run make > make.out 2>&1
	-M [Macro] - Define make macro. e.g. make FOO="Bar"
	-n [Envir] - Define environment variable for make. e.g. FOO="BAR make
	-r - Redirect output to just screen
	-R - Redirect output to screen and file
	-s [Envir] - Define environment variable for make test. e.g. FOO=BAR make test
	-t - Run make test > test.out 2>&1
	-T - Run make check > test.out 2>&1
	-u [Macro] - Define make macro for test. e.g. make FOO=BAR test
	-z - Turn on DEBUG mode. Simply echo's commands (-r|-R) needed for STDOUT
EOF
	exit 1
}

# OPTERR=0
DEBUG=
CONFDEF=
MAKEENV=
MAKEMACRO=
RUNDIR="."
RUNCONF=
RUNMAKE=
RUNTEST=
TESTENV=
TESTMACRO=
RUNINST=
RUNCHECK=
RUNDEBUG=
REDIRECT='> $OUTPUT 2>&1'
TEE=
VERBOSE=
args=
BUILD=
STAGE=
PASS=
SCRIPT=$0
TIMETMPFILE=/tmp/$$-tmp-build.dat


while getopts ":b:cC:d:iM:mn:rRs:tTu:vz" args; do
	case $args in
	b) BUILD=$OPTARG ;;
	c) RUNCONF=1 ;;
	C) CONFDEF=$OPTARG; RUNCONF=1 ;;
	d) RUNDIR=$OPTARG ;;
	i) RUNINST=1 ;;
	m) RUNMAKE=1 ;;
	M) MAKEMACRO=$OPTARG; RUNMAKE=1 ;;
	n) MAKEENV=$OPTARG; RUNMAKE=1 ;;
	r) TEE="| tee"; REDIRECT=  ;;
	R) TEE='| tee $OUTPUT'; REDIRECT= ;;
	s) TESTENV=$OPTARG ;;
	t) RUNTEST=1 ;;
	T) RUNCHECK=1 ;;
	u) TESTMACRO=$OPTARG ;;
	v) VERBOSE=1 ;;
	z) DEBUG="echo" ;;
	*) Usage ;;
	esac
done

if [[ -z $BUILD ]]; then
	echo "$0: Error - You must specify build name using -b Name"
	Usage
fi

{
	time {
		if [[ ${RUNCONF:-""} ]]; then
			RUNCONF="$CONDEF $RUNDIR/configure --prefix=/tools"
			OUTPUT=$CONFOUT
			eval $DEBUG $CONFDEF $RUNDIR/configure --prefix=/tools ${REDIRECT:-$TEE}
			[[ $? -ne 0 ]] && exit 1
		fi

		if [ ${RUNMAKE:-""} ]; then
			RUNMAKE="$MAKEENV make $MAKEMACRO"
			OUTPUT=$MAKEOUT
			eval $DEBUG $MAKEENV make $MAKEMACRO ${REDIRECT:-$TEE}
			[[ $? -ne 0 ]] && exit 1
		fi

		if [ ${RUNTEST:-""} ]; then
			RUNTEST="$TESTENV make $TESTMACRO test"
			OUTPUT=$TESTOUT
			eval $DEBUG $TESTENV make $TESTMACRO test ${REDIRECT:-$TEE}
			[[ $? -ne 0 ]] && exit 1
		fi

		if [ ${RUNCHECK:-""} ]; then
			RUNCHECK="$TESTENV make $TESTMACRO check"
			OUTPUT=$TESTOUT
			eval $DEBUG $TESTENV make $TESTMACRO check ${REDIRECT:-$TEE}
			[[ $? -ne 0 ]] && exit 1
		fi

		if [ ${RUNINST:-""} ]; then
			RUNINST="make install"
			OUTPUT=$INSTOUT
			eval $DEBUG make install ${REDIRECT:-$TEE}
			[[ $result -ne 0 ]] && exit 1
		fi
	} 
} 2> $TIMETMPFILE

#
# Default the time related data in case we don't care to fill it in.
#

PASS=${PASS:=1}
STAGE=${STAGE:=1}
BUILD=${BUILD:="unknown"}

if [ -z $DEBUG ]
then
	echo "$BUILD,$STAGE,$PASS,$(basename $SCRIPT),$(cat $TIMETMPFILE | xargs -r | sed -e 's/[ ]*real[ ]*//' -e 's/[ ]*user[ ]*/,/' -e 's/[ ]*sys[ ]*/,/')" >> $TIMEDATALOG
	echo "$BUILD,$RUNCONF,$RUNMAKE,$RUNTEST,$RUNCHECK,$RUNINST" >> $BUILDGENERICLOG
else
	echo "$BUILD,$STAGE,$PASS,$(basename $SCRIPT),$(cat $TIMETMPFILE | xargs -r | sed -e 's/[ ]*real[ ]*//' -e 's/[ ]*user[ ]*/,/' -e 's/[ ]*sys[ ]*/,/')"
	echo "$BUILD,$RUNCONF,$RUNMAKE,$RUNTEST,$RUNCHECK,$RUNINST"
fi


rm -f $TIMETMPFILE
