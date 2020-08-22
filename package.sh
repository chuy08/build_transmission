#!/usr/bin/env bash

LIBEVENT_VERSION=2.1.12
TRANSMISSION_VERSION=3.00

LIBEVENT_FILE_NAME=libevent-${LIBEVENT_VERSION}-stable.tar.gz
TRANSMISSION_FILE_NAME=transmission-${TRANSMISSION_VERSION}.tar.xz

LIBEVENT_DL="https://github.com/libevent/libevent/releases/download/release-${LIBEVENT_VERSION}-stable/${LIBEVENT_FILE_NAME}"
TRANMISSION_DL="https://github.com/transmission/transmission/releases/download/${TRANSMISSION_VERSION}/${TRANSMISSION_FILE_NAME}"

#echo $LIBEVENT_DL
#echo $TRANMISSION_DL
#echo $LIBEVENT_FILE_NAME

# Create package directory
[ ! -f /pkg_dir ] && mkdir -p /pkg_dir

# Testing if files exists, if not download them
[ ! -f $LIBEVENT_FILE_NAME ] && curl -L $LIBEVENT_DL -o $LIBEVENT_FILE_NAME
[ ! -f $TRANSMISSION_FILE_NAME ] && curl -L $TRANMISSION_DL -o $TRANSMISSION_FILE_NAME

# Extract both packages to root directory
tar -C / -xf $LIBEVENT_FILE_NAME
tar -C / -xf $TRANSMISSION_FILE_NAME

# Building and installing
cd /libevent-$LIBEVENT_VERSION-stable
./configure --prefix /opt/libevent-$LIBEVENT_VERSION
make
make install
make DESTDIR=/pkg_dir install

# Building and installing to pkg_dir
cd /transmission-$TRANSMISSION_VERSION
PKG_CONFIG_PATH=/opt/libevent-$LIBEVENT_VERSION/lib/pkgconfig ./configure --prefix /opt/transmission-$TRANSMISSION_VERSION --enable-cli --enable-daemon --enable-utp
make
make DESTDIR=/pkg_dir install

# Make a Debian package
fpm -f -s dir -t deb -n transmission -p /work -v ${TRANSMISSION_VERSION} /pkg_dir/opt=/
