#!/bin/bash

# This script installs the XSL stylesheets for docbook
#

install -v -m755 -d /usr/share/xml/docbook/xsl-stylesheets-1.79.2 > install.out 2>&1 &&

cp -v -R VERSION assembly common eclipse epub epub3 extensions fo        \
         highlighting html htmlhelp images javahelp lib manpages params  \
         profiling roundtrip slides template tests tools webhelp website \
         xhtml xhtml-1_1 xhtml5                                          \
    /usr/share/xml/docbook/xsl-stylesheets-1.79.2 >> install.out 2>&1 &&

ln -sv VERSION /usr/share/xml/docbook/xsl-stylesheets-1.79.2/VERSION.xsl >> install.out 2>&1  &&

install -v -m644 -D README \
                    /usr/share/doc/docbook-xsl-1.79.2/README.txt >> install.out 2>&1 &&
install -v -m644    RELEASE-NOTES* NEWS* install.sh add-xls-sheets.template.sh \
                    /usr/share/doc/docbook-xsl-1.79.2 >> install.out 2>&1 &&
cp -v -R doc/* /usr/share/doc/docbook-xsl-1.79.2 >> install.out 2>&1
