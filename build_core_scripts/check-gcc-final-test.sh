#!/bin/bash

# This script runs the tests for the final version of gcc.

time {
	SED=sed		\
	TCL_LIBRARY=/tools/lib/tcl8	\
	DEJAGNULIBS=/tools/share/dejagnu \
	&& ulimit -s 32768	\
	&& make -k check > test.out 2>&1 \
	&& ../contrib/test_summary >> test.out 2>&1 ;
#	&& make install > install.out 2>&1 ;
}

