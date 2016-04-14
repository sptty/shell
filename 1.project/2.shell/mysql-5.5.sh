#!/bin/bash
#
#
#####################################################################
#
#first lease was by wrrited by sptty .  mail: 747824617@qq.com
#   lease time Fri Oct  27  PST 2015
#desciprtion:
#automaticing install mysql by shell script.
#mysql is a database  server. 



wget -P  /usr/local/src http://172.19.1.253/files/mysql-5.5.20-linux2.6-x86_64.tar.gz
cd /usr/local/src 
tar xf mysql-5.5.20-linux2.6-x86_64.tar.gz
mv /usr/local/src/mysql-5.5.20-linux2.6-x86_64  /usr/local/mysql

rpm -e mysql-server --nodeps

cp /usr/local/mysql/support-files/my-huge.cnf /etc/my.cnf

mkdir -p /data/mysql

usermod -s /sbin/nologin mysql

chown -R  mysql.mysql /data/mysql

sed -i '/^\[mysqld\]/a\datadir=\/data\/mysql' /etc/my.cnf
sed -i '/^\[mysqld\]/a\basedir=\/usr\/local/mysql' /etc/my.cnf


cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld

sed -i '1,$s#^datadir=#datadir=/data/mysql#g'  /etc/init.d/mysqld
sed -i '1,$s#^basedir=#basedir=/usr/local/mysql#g'  /etc/init.d/mysqld

chmod +x /etc/init.d/mysqld
chkconfig --add mysqld
chkconfig mysqld on

cd /usr/local/mysql

./scripts/mysql_install_db  --basedir=/usr/local/mysql --datadir=/data/mysql --defaults-file=/etc/my.cnf --user=mysql &

/etc/init.d/mysqld restart
