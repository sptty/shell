#!/bin/bash
#
#
#####################################################################
#
#first lease was by wrrited by sptty .  mail: 747824617@qq.com
#   lease time Fri Oct  26  PST 2015
#desciprtion:
#automaticing install php as php-fpm  by shell script.
#####################################################################

#
# Source function library.
. /etc/rc.d/init.d/functions
 
# Source networking configuration.
. /etc/sysconfig/network
 
# Check that networking is up.
#[ "$NETWORKING" = "no" ] && exit 0

#pre-install packages by yum when installing php
#yum  -y groupinstall 'Compatibility libraries' 'Development tools'
yum -y install pcre-devel  bzip2-devel  openssl-devel  >> /dev/null  && echo 'yum success......' || echo 'yum failed ' 
yum -y install libmcrypt-devel  mhash-devel libevent-devel \
 mcrypt-devel libcurl-devel >> /dev/null && echo 'yum success......' || echo 'yum failed ' 



wget -P /usr/local/src/ http://172.19.1.253/files/re2c-0.14.3.tar.gz

cd  /usr/local/src/

tar xf re2c-0.14.3.tar.gz
cd re2c-0.14.3*
./configure
make
make install 

sleep 3

wget -P /usr/local/src/ http://172.19.1.253/files/php-5.5.30.tar.bz2

cd /usr/local/src/

#install  php
tar xf php-5.5.30.tar.bz2 
cd /usr/local/src/php-5.5.30

./configure  --prefix=/usr/local/php --enable-fpm \
    --with-fpm-user=php-fpm--with-fpm-group=php-fpm \
    --with-config-file-path=/etc \
    --with-config-file-scan-dir=/etc/php.d --with-mysql=/usr/local/mysql \
    --with-mysqli=/usr/local/mysql/bin/mysql_config  --with-iconv-dir \
    --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib \
    --with-libxml-dir=/usr --enable-xml --disable-rpath --enable-bcmath \
    --enable-shmop --enable-sysvsem --with-curl --enable-mbregex \
    --enable-mbstring  --with-pdo-mysql=/usr/local/mysql \
    --with-mcrypt --enable-ftp --with-gd --enable-gd-native-ttf --with-openssl \
    --with-mhash --enable-pcntl --enable-sockets --with-xmlrpc --enable-zip \
    --enable-soap --without-pear --with-gettext --disable-fileinfo  --with-bz2    \
    --enable-opcache=no >> /dev/null  && echo ' php  configure success......' ||  echo ' php  configure failed ....'

make >> /dev/null && echo ' php  make  success......' || echo ' php  make  failed ....'

make install >> /dev/null  && echo ' php  make install success......' || echo ' php  make install failed ....'


##################################
#configuraion php-fpm 

#copy configure file 
cd /usr/local/src/php-5.5.30/
cp php.ini-production /etc/php.ini

#cp sapi  as  /etc/init.d/php-fpm
cp sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm 

useradd -s /sbin/nologin php-fpm


cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf 

sed -i '1,$s/user = nobody/user = php-fpm/g' /usr/local/php/etc/php-fpm.conf
sed -i '1,$s/^group = nobody/group = php-fpm/g' /usr/local/php/etc/php-fpm.conf

chmod -R 750 /usr/local/nginx/html/
chown -R php-fpm.nginx /usr/local/nginx/html/

chmod +x /etc/init.d/php-fpm
chkconfig --add php-fpm
chkconfig php-fpm on


#setting php configure file

sed -i 's/pm.max_children = 5/pm.max_children = 150/' /usr/local/php/etc/php-fpm.conf
sed -i 's/pm.start_servers = 2/pm.start_servers = 8/' /usr/local/php/etc/php-fpm.conf
sed -i 's/pm.min_spare_servers = 1/pm.min_spare_servers = 5/' /usr/local/php/etc/php-fpm.conf
sed -i 's/pm.max_spare_servers = 3/pm.max_spare_servers = 10/' /usr/local/php/etc/php-fpm.conf
sed -i '/php-fpm.pid/a\pid = \/usr\/local\/php\/var\/run\/php-fpm.pid' /usr/local/php/etc/php-fpm.conf

sed -i '1,$s/fastcgi_pass   127.0.0.1:9000;/#fastcgi_pass   127.0.0.1:9000;/' /usr/local/nginx/nginx.conf
sed -i '1,$s/#fastcgi_pass   127.0.0.1:9000;/a\  fastcgi_pass  unix:/dev/shm/php-fpm.sock;' /usr/local/nginx/nginx.conf

sed -i '1,$s/listen = 127.0.0.1:9000/#listen = 127.0.0.1:9000/g'      /usr/local/php/etc/php-fpm.conf
sed -i '/^#listen = 127.0.0.1:9000/a\listen = /dev/shm/php-fpm.sock;'  /usr/local/php/etc/php-fpm.conf


touch /dev/shm/php-fpm.sock
chown php-fpm.nginx /dev/shm/php-fpm.sock
chmod 750  /dev/shm/php-fpm.sock

echo 'PATH=$PATH:/usr/local/php/bin' >> /etc/profile

#start  php
/etc/init.d/php-fpm restart

rm -rf /root/$0

#reboot

exit 0
