#!/bin/bash
#
#
#####################################################################
#
#first lease was by wrrited by sptty .  mail: 747824617@qq.com
#   lease time Fri Oct  22  PST 2015
#desciprtion:
#setting java environment
#####################################################################

#
# Source function library.
. /etc/init.d/functions

wget -P /usr/local/src  http://172.19.1.253/files/jdk1.7.0_79.tar.gz
cd /usr/local/src
tar xf jdk1.7.0_79.tar.gz -C /usr/local/

echo \
'JAVA_HOME=/usr/local/jdk1.7.0_79
JAVA_BIN=/usr/local/jdk1.7.0_79/bin
JRE_HOME=/usr/local/jdk1.7.0_79/jre
PATH=$PATH:/usr/local/jdk1.7.0_79/bin:/usr/local/jdk1.7.0_79/jre/bin
CLASSPATH=/usr/local/jdk1.7.0_79/jre/lib:/usr/local/jdk1.7.0_79/lib:/usr/local/jdk1.7.0_79/jre/lib/charsets.jar' >> /etc/profile.d/java.sh

echo 'MANPATH  /usr/local/jdk1.7.0_79/man'  >> /etc/man.config

. /etc/profile.d/java.sh

rm -rf /root/$0
bash
exit 0
