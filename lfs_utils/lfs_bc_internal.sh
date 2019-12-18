#!/bin/bash

# internal script to use sed instead of ed:
pushd /sources/bc-1.07.1 > /dev/null

cat > bc/fix-libmath_h << "EOF"
#! /bin/bash

sed -e '1   s/^/{"/' \
    -e     's/$/",/' \
    -e '2,$ s/^/"/'  \
    -e   '$ d'       \
    -i libmath.h

sed -e '$ s/$/0}/' \
    -i libmath.h
EOF

popd > /dev/null
