#!/bin/bash

#
# Create a full version of the internal header using a command
# that is identical to what the GCC build system does in normal
# circumstances.
#
# Run this command in gcc-7.2.0 directory.
pushd /lfsbuild/sources/gcc-7.2.0 > /dev/null || exit 1

cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
	`dirname $(x86_64-lfs-linux-gnu-gcc -print-libgcc-file-name)`/include-fixed/limits.h
echo "Creating $(dirname $(x86_64-lfs-linux-gnu-gcc -print-libgcc-file-name))/include-fixed/limits.h"

popd > /dev/null

