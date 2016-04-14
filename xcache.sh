#!/bin/bash
#
#
#####################################################################
#
#first lease was by wrrited by sptty .  mail: 747824617@qq.com
#   lease time Fri Oct  26  PST 2015
#desciprtion:
#automaticing install xcache by shell script.
#xcache is an opcode  cache 
#####################################################################

#
# Source function library.
. /etc/rc.d/init.d/functions
 
# Source networking configuration.
. /etc/sysconfig/network
 
# Check that networking is up.
#[ "$NETWORKING" = "no" ] && exit 0

#pre-install packages by yum when installing xcache
#yum  -y groupinstall 'Compatibility libraries' 'Development tools'

yum -y install pcre-devel  bzip2-devel  openssl-devel  >> /dev/null  && echo 'yum success......' || echo 'yum failed ' 
yum -y install libmcrypt-devel  mhash-devel libevent-devel \
 mcrypt-devel libcurl-devel >> /dev/null && echo 'yum success......' || echo 'yum failed ' 


#download xcache source codes
wget -P /usr/local/src/ http://172.19.1.253/files/xcache-3.1.2.tar.gz
cd /usr/local/src/

#install  xache

tar xf xcache-3.1.2.tar.gz 
cd xcache-3.1.2
/usr/local/php/bin/phpize
./configure --enable-xcache --with-php-config=/usr/local/php/bin/php-config \
>> /dev/null  && echo ' php  configure success......' ||  echo ' php  configure failed ....'

make >> /dev/null && echo ' php  make  success......' || echo ' php  make  failed ....'

make install >> /dev/null  && echo ' php  make install success......' || echo ' php  make install failed ....'


##################################
#configuraion  xcache

#copy configure file 
cd  /usr/local/src/xcache-3.1.2
mkdir /etc/php.d
cp xcache.ini  /etc/php.d

#setting xcache.ini configure file

XCACHE_SO_PATH=`find /usr/local/php/ -name xcache.so`
sed -i "3a\\extension = $XCACHE_SO_PATH" /etc/php.d/xcache.ini 
sed -i '/xcache.admin.enable_auth/s/On/Off/' /etc/php.d/xcache.ini
#XCACHE_PASS=`echo 'yungui2015' |openssl md5|cut -d '=' -f2`


#copy web mointor to htdocs

cd  /usr/local/src/xcache-3.1.2
cp -rp htdocs /usr/local/apache/htdocs/xcache

#start  xcache 

/etc/init.d/php-fpm restart

rm -rf /root/$0

exit 0
