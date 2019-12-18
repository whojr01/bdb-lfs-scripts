#!/bin/bash

# This builds, tests, and installs flex.

time {
	HELP2MAN=/tools/bin/true	\
	../configure --prefix=/usr	\
		--docdir=/usr/share/doc/flex-2.6.4 > config.out 2>&1 \
	&& make > make.out 2>&1 \
	&& make check > test.out 2>&1 \
	&& make install > install.out 2>&1 ;
}

