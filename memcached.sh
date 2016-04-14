#!/bin/bash
#
#
#####################################################################
#
#first lease was by wrrited by sptty .  mail: 747824617@qq.com
#   lease time Fri Oct  22  PST 2015
#desciprtion:
#install memcachd
#####################################################################

#
# Source function library.
. /etc/init.d/functions

yum install -y libevent-devel

wget -P /usr/local/src/ http://172.19.1.253/files/memcached-1.4.24.tar.gz
cd /usr/local/src/
tar xf memcached-1.4.24.tar.gz
cd memcached-1.4.24
./configure --prefix=/usr/local/memcached &>> /dev/null
make &>> /dev/null
make install &>> /dev/null
ln -s /usr/local/memcached/bin/memcached   /usr/local/bin/memcached
cp /usr/local/src/memcached-1.4.24/scripts/memcached-tool /usr/bin/

echo '#memcached -u root -d -m 100m -f 1.1 -u root 0.0.0.0 -p 11211 -P /var/run/memcached.pid' >> /etc/rc.local
rm -rf /root/memcached.sh

exit 0

