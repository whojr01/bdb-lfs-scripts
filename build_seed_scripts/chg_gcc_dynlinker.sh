#!/bin/bash

# Change the location of GCC's default dynamic linker to use the one
# installed in /tools. It also removes /usr/include from GCC's include
# search path. Issue:

pushd /lfsbuild/sources/gcc-7.2.0 > /dev/null || exit 1

for file in gcc/config/{linux,i386/linux{,64}}.h
do
	cp -uv $file{,.orig}
	sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' \
	    -e 's@/usr@/tools@g' $file.orig > $file
	echo '
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
#define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
	touch $file.orig
done

popd > /dev/null

