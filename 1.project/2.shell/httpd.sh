#!/bin/bash
#
#
#####################################################################
#
#first lease was by wrrited by sptty .  mail: 747824617@qq.com
#   lease time Fri Oct  26  PST 2015
#desciprtion:
#automaticing install httpd by shell script.
#####################################################################


##this is a test
#
# Source function library.
. /etc/init.d/functions

#pre-install packages by yum when installing httpd
#yum  -y groupinstall 'Compatibility libraries' 'Development tools'
yum install pcre-devel  bzip2-devel  openssl-devel -y

wget -P /usr/local/src/ http://172.19.1.253/files/apr-1.4.6.tar.bz2
wget -P /usr/local/src/ http://172.19.1.253/files/apr-util-1.4.1.tar.bz2
#wget -P /usr/local/src/ http://172.19.1.253/files/php-5.4.0.tar.bz2
wget -P /usr/local/src/ http://172.19.1.253/files/httpd-2.4.1.tar.bz2

cd /usr/local/src/

#install apr 
tar xf apr-1.4.6.tar.bz2 
cd apr-1.4.6
./configure --prefix=/usr/local/apr 
make
make install && echo 'apr installed success......'


#install apr-util 
cd ../
tar xf apr-util-1.4.1.tar.bz2 
cd apr-util-1.4.1
./configure --prefix=/usr/local/apr-util --with-apr=/usr/local/apr 
make && make install  && echo 'apr-util  installed success......'

#install httpd 
cd ../
tar xf  httpd-2.4.1.tar.bz2 
cd httpd-2.4.1  

./configure --prefix=/usr/local/apache --sysconfdir=/etc/httpd   --with-pcre \
  --with-apr=/usr/local/apr --with-apr-util=/usr/local/apr-util --enable-so \
  --enable-rewirte --enable-ssl --enable-cgi --enable-cgid   --enable-proxy-fcgi \
  --enable-proxy-fcgi    --enable-proxy     --enable-http  --enable-modules=most \
  --enable-mods-shared=most --enable-mpms-shared=all 

make && make install && echo 'httpd installed success......'


#setting httpd envirement 

#cp apachectl as  /etc/init.d/httpd
cp -p /usr/local/apache/bin/apachectl /etc/init.d/httpd
sed -i '2a\  '  /etc/init.d/httpd
sed -i '3a\# chkconfig:   345 85 15' /etc/init.d/httpd
sed -i '4a\# description: httpd        Startup script for the Apache HTTP Server' /etc/init.d/httpd

#wget -P /etc/init.d/ http://172.19.1.253/files/httpd 
chmod +x /etc/init.d/httpd
chkconfig --add httpd
chkconfig httpd on




#setting php variablers
sed -i 's/^[[:space:]].*DirectoryIndex/& index.php/'  /etc/httpd/httpd.conf
sed -i '/PidFile/a\PidFile "/var/run/httpd.pid"'  /etc/httpd/httpd.conf
sed -i '/AddType application\/x-gzip .gz .tgz/a\    AddType application\/x-httpd-php-source  .phps'  /etc/httpd/httpd.conf
sed -i '/AddType application\/x-gzip .gz .tgz/a\    AddType application\/x-httpd-php  .php'  /etc/httpd/httpd.conf
sed -i '/sets the file/a\<\/IfModule>'  /etc/httpd/httpd.conf
sed -i '/sets the file/a\ProxyPassMatch ^/(.*\\.php(/.*)?)$ fcgi://127.0.0.1:9000/usr/local/apache/htdocs/$1'  /etc/httpd/httpd.conf
sed -i '/sets the file/a\<IfModule mpm_event_module>'  /etc/httpd/httpd.conf
sed -i 's/#ServerName www.example.com:80/ServerName 127.0.0.1:80/' /etc/httpd/httpd.conf
sed -i '/mod_slotmem_shm/s/#//' /etc/httpd/httpd.conf

# export httpd bin 
echo 'export PATH=$PATH:/usr/local/apache/bin' >> /etc/bashrc

#export httpd man 
echo 'MANPATH  /usr/local/apache/man  '  >> /etc/man.config


rm -rf /root/$0

#reboot

bash 

exit 0
