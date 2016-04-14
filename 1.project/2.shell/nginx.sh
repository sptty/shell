#!/bin/bash
#
#
#####################################################################
#
#first lease was by wrrited by sptty .  mail: 747824617@qq.com
#   lease time Fri Oct  27  PST 2015
#desciprtion:
#automaticing install nginx by shell script.
#nginx is a light and fast web server. 
#####################################################################

#
# Source function library.
. /etc/rc.d/init.d/functions
 
# Source networking configuration.
. /etc/sysconfig/network
 
# Check that networking is up.
#[ "$NETWORKING" = "no" ] && exit 0

#pre-install packages by yum when installing nginx
#yum  -y groupinstall 'Compatibility libraries' 'Development tools'

yum -y install pcre-devel  bzip2-devel  openssl-devel  >> /dev/null  && echo 'yum success......' || echo 'yum failed ' 
yum -y install libmcrypt-devel  mhash-devel libevent-devel \
 mcrypt-devel libcurl-devel >> /dev/null && echo 'yum success......' || echo 'yum failed ' 


#download nginx source codes
wget -P /usr/local/src/ http://172.19.1.253/files/nginx-1.8.0.tar.gz
cd /usr/local/src/

#install  nginx by complied
tar xf nginx-1.8.0.tar.gz
cd nginx-1.8.0

 ./configure \
 --prefix=/usr/local/nginx \
 --conf-path=/usr/local/nginx/nginx.conf \
 --error-log-path=/usr/local/nginx/logs/error.log \
 --http-log-path=/usr/local/nginx/logs/access.log \
 --pid-path=/usr/local/nginx/logs/nginx.pid  \
 --lock-path=/usr/local/nginx/logs/nginx.lock \
 --user=nginx \
 --group=nginx \
 --with-http_ssl_module \
 --with-http_flv_module \
 --with-http_stub_status_module \
 --with-http_gzip_static_module \
 --http-client-body-temp-path=/usr/local/nginx/client/ \
 --http-proxy-temp-path=/usr/local/nginx/proxy/ \
 --http-fastcgi-temp-path=/usr/local/nginx/fcgi/ \
 --http-uwsgi-temp-path=/usr/local/nginx/uwsgi \
 --http-scgi-temp-path=/usr/local/nginx/scgi \
 --with-pcre >> /dev/null  && echo ' nginx  configure success......' ||  echo ' nginx  configure failed ....'

make >> /dev/null && echo ' nginx  make  success......' || echo ' nginx  make  failed ....'

make install >> /dev/null  && echo ' nginx  make install success......' || echo ' nginx  make install failed ....'


##################################
#configuraion  nginx

#add user nginx 
groupadd -r nginx
useradd -s /sbin/nologin -r -g nginx nginx

#copy configure file 
cd  /usr/local/src/nginx-1.8.0

wget -P /etc/init.d/ http://172.19.1.253/files/nginx
chmod +x /etc/init.d/nginx

chkconfig --add nginx
chkconfig nginx on

#confiure php
sed -i '/FastCGI/,+8s/#//' /usr/local/nginx/nginx.conf
sed -i '/FastCGI/s/^/#/' /usr/local/nginx/nginx.conf

sed -i '/worker_processes/s/1/12/' /usr/local/nginx/nginx.conf 
sed -i '/worker_processes/a\worker_cpu_affinity 000000000001 000000000010 000000000100 000000001000 000000010000 000000100000 000001000000 000010000000 000100000000 001000000000 010000000000 100000000000 ;' /usr/local/nginx/nginx.conf 



 
rm -rf  /usr/local/nginx/fastcgi_params
wget -P /usr/local/nginx/ http://172.19.1.253/files/fastcgi_params

chown php-fpm.nginx  /usr/local/nginx/fastcgi_params
chown -R php-fpm.nginx /usr/local/nginx

sed -i '/^#pid/a\pid        /usr/local/nginx/logs/nginx.pid;'  /usr/local/nginx/nginx.conf



#cutting nginx log

echo '/usr/local/nginx/logs/*.log {
daily
rotate 7
missingok
notifempty
dateext
sharedscripts
postrotate
if [ -f /usr/local/nginx/logs/nginx.pid ]; then    
    kill -USR1 `cat /usr/local/nginx/logs/nginx.pid` 
fi    
endscript 
}'> /etc/logrotate.d/nginx


crontab -l > /tmp/crontab.txt
echo '00 00 3 * *  /usr/sbin/logrotate -f /etc/logrotate.d/nginx' >> /tmp/crontab.txt
cat /tmp/crontab.txt |crontab
rm  -rf /tmp/crontab.txt


#start  nginx 

/etc/init.d/nginx restart && echo "nginx restart success" || echo "nginx start failed "

rm -rf /root/$0

exit 0
