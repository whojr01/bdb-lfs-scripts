#!/bin/bash

# This script creates a c program called dummy.c to determine
# compiler settings.
#

COMPILER=${1-"gcc"}

if [ -f "dummy.c" ] ; then
	rm -f dummy.c
fi

echo 'int main(){}' > dummy.c
echo Using Compiler: $COMPILER

$COMPILER dummy.c -v -Wl,--verbose &> dummy.log

if [ -f "a.out" ] ; then
	elflib=$(readelf -l a.out | grep 'interpreter')
	elfstart=$(grep -o '.*/lib.*/crt[1in].*succeeded' dummy.log)
	elfheaders=$(grep -B4 '^ /usr/include' dummy.log)
	elfsearch=$(grep SEARCH dummy.log | sed 's|; |\n|g')
	elflibc=$(grep ".*/libc.so.6" dummy.log)
	elffound=$(grep found dummy.log)
	rm a.out dummy.c dummy.log
	echo "*********************"
	echo "ELF report"
	echo "*********************"
	echo "Interpreter:"
	echo "$elflib"
	echo
	echo "Start (ctors):"
	echo "$elfstart"
	echo 
	echo "Headers:"
	echo "$elfheaders"
	echo
	echo "Search Dirs:"
	echo "$elfsearch"
	echo
	echo "Libc:"
	echo "$elflibc"
	echo
	echo "Found:"
	echo "$elffound"
	echo 
	echo done.
else
	echo a.out not generated
	echo not removing dummy.c or dummy.log
fi


