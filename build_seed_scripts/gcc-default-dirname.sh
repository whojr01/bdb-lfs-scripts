#!/bin/bash

# This script is needed if building on x86_64. Need to
# change the default directory name for 64-bit libraries
# to lib.

pushd $LFS/sources/gcc-7.2.0 > /dev/null || exit 1
sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64
echo "Diffing gcc/config/i386/t-linux64 gcc/config/i386/t-linux64.orig"
diff gcc/config/i386/t-linux64 gcc/config/i386/t-linux64.orig
popd > /dev/null

