#!/bin/bash

# This builds, tests, and installs bison.

time {
	../configure --prefix=/usr	\
		--docdir=/usr/share/doc/bison-3.0.4 > config.out 2>&1 \
	&& make > make.out 2>&1 \
	&& make install > install.out 2>&1 ;
}

