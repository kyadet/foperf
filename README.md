# foperf
Fan-Out performance checking tool

# setup for linux
yum install golang gcc gcc-devel gcc-c++ libtool automake autoconf git pkgconfig libunwind libunwind-devel

git clone git://github.com/jedisct1/libsodium.git
git clone git://github.com/zeromq/libzmq.git
git clone git://github.com/zeromq/czmq.git

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

go get github.com/zeromq/goczmq

# foperf build
git clone git://github.com/kyadet/foperf.git
cd foperf
./build.sh

# execute server
./wake_relay.sh

# execute client
./wake_client.sh
