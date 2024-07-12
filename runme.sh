#!/bin/bash

MODULE=xserve-frontpanel
VERSION=1.0

if (test $UID -ne 0); then echo Run as root && exit; fi

case "$1" in
  install)
    mkdir /usr/src/$MODULE-$VERSION
    for i in "dkms.conf Makefile $MODULE.c"; do cp $i /usr/src/$MODULE-$VERSION/; done
    dkms add -m $MODULE -v $VERSION
    dkms build -m $MODULE -v $VERSION
    dkms install -m $MODULE -v $VERSION
    dkms status | grep $MODULE && modprobe xserve_frontpanel
    lsmod | grep xserve_frontpanel
    ;;
  uninstall)
    modprobe -r xserve_frontpanel
    dkms uninstall -m $MODULE -v $VERSION
    dkms remove -m $MODULE -v $VERSION
    dkms status | grep $MODULE || echo Module Uninstalled
    rm -rf /usr/src/$MODULE-$VERSION
    ;;
  *)
    echo "USAGE: $0 <install|uninstall>"
esac
