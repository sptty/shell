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

yum -y install vsftpd openssl &>> /dev/null

mkdir -p /ftp 



useradd -s /sbin/nologin/ -d /ftp  ftpuser1
PASSWD=`openssl rand 6 -base64`
echo "${PASSWD}" | passwd --stdin ftpuser1 


echo 'anonymous_enable=NO
local_enable=YES
write_enable=YES
local_root=/ftp
#cmds_allowed=CWD,LIST,MKD,PWD,RNFR,RNTO,STOR,PASS,PASV,PORT,QUIT,TYPE,USER,
download_enable=NO
chroot_local_user=YES
anon_root=/ftp
local_umask=022
dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
xferlog_std_format=YES
listen=YES
pam_service_name=vsftpd
userlist_enable=YES
tcp_wrappers=YES
userlist_deny=YES' > /etc/vsftpd/vsftpd.conf

/etc/init.d/vsftpd restart

echo "you ftp user is ftpuser1, password is ${PASSWD}"

rm -rf $0 

exit 