#!/bin/bash

install -v -d -m755 /usr/share/xml/docbook/xml-dtd-4.5 > install.out 2>&1 &&
install -v -d -m755 /etc/xml >> install.out 2>&1 &&
chown -Rv root:root . >> install.out 2>&1 &&
cp -v -af docbook.cat *.dtd ent/ *.mod \
    /usr/share/xml/docbook/xml-dtd-4.5 >> install.out 2>&1 
