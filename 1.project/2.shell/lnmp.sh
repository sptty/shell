#!/bin/bash
#
#
#####################################################################
#
#first lease was by wrrited by sptty .  mail: 747824617@qq.com
#   lease time Fri Nov  27  PST 2015
#desciprtion:
#automaticing install vsftpd by shell script.
#
#####################################################################

#
# Source function library.
. /etc/rc.d/init.d/functions
 
# Source networking configuration.
. /etc/sysconfig/network
 
# Check that networking is up.
#[ "$NETWORKING" = "no" ] && exit 0


#download shell as list below:
#	nginx.sh
#	mysql-5.5.sh 
#	php-5.4.sh 
#	


wget -P /root/ http://172.19.1.253/nginx.sh || exit 8
sh /root/nginx.sh && echo && 'nginx install successed' && wget -P /root/ http://172.19.1.253/mysql-5.5.sh || exit 8
sh /root/mysql-5.5.sh && echo && 'mysql-5.5.sh install successed' && wget -P /root/ http://172.19.1.253/php-5.4.sh  || exit 8
sh /root/php-5.4.sh && echo && 'php-5.4 install successed' || exit 8
