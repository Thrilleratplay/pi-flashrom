#!/bin/bash -e

on_chroot << EOF
  curl -L http://download.flashrom.org/releases/flashrom-0.9.9.tar.bz2 | tar -xj
  cd flashrom-0.9.9/
  make
  sudo make install
  cd ../
  rm -rf flashrom-0.9.9/
EOF


install -v -d                                  ${ROOTFS_DIR}/home/pi/
install -v -m 755 files/bash_aliases           ${ROOTFS_DIR}/home/pi/.bash_aliases
