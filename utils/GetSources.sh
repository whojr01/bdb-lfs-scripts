#!/bin/bash

# HTTP request sent, awaiting response... 404 Not Found
# 2018-01-01 08:24:54 ERROR 404: Not Found.


SRC=$LFS/data-files/wget-list
DEST=$LFS/sources
OUT=$LFS/data-files/wget-list-output

# wget --input-file=$SRC --continue --directory-prefix=$DEST > $OUT 2>&1

[[ $(grep -F ERROR $OUT ) ]] && echo "Check logs errors identified"
