#!/bin/bash

# GCC requires the GMP, MPFR, and MPC packages so copy them in there.
#

pushd /lfsbuild/sources/gcc-7.2.0 > /dev/null || exit 1
tar xvf /lfsbuild/sources/mpfr-3.1.6.tar.xz
mv -v mpfr-3.1.6 mpfr

tar xvf /lfsbuild/sources/gmp-6.1.2.tar.xz
mv -v gmp-6.1.2 gmp

tar xvf /lfsbuild/sources/mpc-1.0.3.tar.gz
mv -v mpc-1.0.3 mpc

popd > /dev/null || exit 1

