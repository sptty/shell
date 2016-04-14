#!/bin/bash
#
#
#####################################################################
#
#first lease was by wrrited by sptty .  mail: 747824617@qq.com
#   lease time Thu Mar 31 09:31:48 CST 2016
#desciprtion:
#automaticing install logstash by shell script.
#logstash is a agent that send server log to elasticsearch.
#####################################################################

#
# Source function library.
. /etc/rc.d/init.d/functions

# Source networking configuration.
. /etc/sysconfig/network

# Check that networking is up.
#[ "$NETWORKING" = "no" ] && exit 0

# define avalibar
KICK_SERVER='10.1.166.20'

#pre-install packages by yum when installing nginx
#yum  -y groupinstall 'Compatibility libraries' 'Development tools'

# yum -y install pcre-devel  bzip2-devel  openssl-devel  >> /dev/null  && echo 'yum success......' || echo 'yum failed '
# yum -y install libmcrypt-devel  mhash-devel libevent-devel \
# mcrypt-devel libcurl-devel >> /dev/null && echo 'yum success......' || echo 'yum failed '


#download logstash installed packages

wget -P /usr/local/src/ http://${KICK_SERVER}/files/logstash-2.2.2-1.noarch.rpm
cd /usr/local/src/
rpm -ivh logstash-2.2.2-1.noarch.rpm
mv /opt/logstash /usr/local/

wget  -P  /etc/logstash/conf.d/ http://${KICK_SERVER}/files/logstash-log.conf
sed -i '/^program/s/program=\/opt/program=\/usr\/local/' /etc/init.d/logstash

/etc/init.d/logstash start
chkconfig logstash on


rm -rf /root/$0

exit 0
