#!/bin/bash
#
#
#####################################################################
#
#first lease was by wrrited by sptty .  mail: 747824617@qq.com
#   lease time Fri Oct  25  PST 2015
#desciprtion:
#setting time server.
#####################################################################

###
#add svn test log 

#
# Source function library.
. /etc/init.d/functions

sed -i '/^restrict 127.0.0.1/a\restrict 172.19.1.254\/16 mask 255.255.255.0 nomodify' /etc/ntp.conf
sed -i '/^server/s/server/#server/' /etc/ntp.conf
sed -i '/^#server 3/a\fudge 127.127.1.0 stratum 10' /etc/ntp.conf
sed -i '/^#server 3/a\server 127.127.1.0' /etc/ntp.conf
sed -i '/^#server 3/a\server ntp.sjtu.edu.cn ' /etc/ntp.conf
sed -i '/^#server 3/a\server time.nist.gov ' /etc/ntp.conf

echo '*/1 * * * * /usr/bin/rdate -s time.nist.gov' |crontab

chkconfig --level 345 ntpd on

/etc/init.d/ntpd restart




rm -rf /root/$0
bash
exit 0
