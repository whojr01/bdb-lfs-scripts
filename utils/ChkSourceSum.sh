#!/bin/bash

CheckSumFile=$LFS/data-files/md5sums
OUT=$LFS/data-files/md5sums-out

pushd $LFS/sources > /dev/null
md5sum -c $CheckSumFile > $OUT 2>&1
[[ $(grep -F WARNING $OUT) ]] && echo "WARNINGS FOUND: Check log [$OUT]"
popd > /dev/null
