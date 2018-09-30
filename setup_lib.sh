#!/bin/bash

cd libsodium/

./autogen.sh && ./configure && make && make check

make install

cd -

cd libzmq/

./autogen.sh && ./configure && make && make check

make install

cd -

cd czmq/

./autogen.sh && ./configure && make && make check

make install

cd -

export LD_LIBRARY_PATH=/usr/local/lib

echo /usr/local/lib > /etc/ld.so.conf.d/zmq.conf

ldconfig

echo export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig >> ~/.bash_profile
