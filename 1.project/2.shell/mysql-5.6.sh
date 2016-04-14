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



wget -P  /usr/local/src http://172.19.1.253/files/mysql-5.6.27-linux-glibc2.5-x86_64.tar.gz
cd /usr/local/src 
tar xf mysql-5.6.27-linux-glibc2.5-x86_64.tar.gz && rm -rf mysql-5.6.27-linux-glibc2.5-x86_64.tar.gz
mv /usr/local/src/mysql-5.6.27*  /usr/local/mysql

rpm -e mysql-server --nodeps


mkdir -p /data/mysql

usermod -s /sbin/nologin mysql

chown -R  mysql.mysql /data/mysql

cd  /usr/local/mysql/

rm -rf /etc/my.cnf

cp my.cnf  /etc/

 ./scripts/mysql_install_db --default-files=/etc/my.cnf  --basedir=/usr/local/mysql/ --datadir=/data/mysql --user=mysql &


sed -i '/^\[mysqld\]/a\datadir=\/data\/mysql' /etc/my.cnf
sed -i '/^\[mysqld\]/a\basedir=\/usr\/local/mysql' /etc/my.cnf


cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld

sed -i '1,$s#^datadir=#datadir=/data/mysql#g'  /etc/init.d/mysqld
sed -i '1,$s#^basedir=#basedir=/usr/local/mysql#g'  /etc/init.d/mysqld

chmod +x /etc/init.d/mysqld
chkconfig --add mysqld
chkconfig mysqld on


rm -rf /etc/ld.so.conf.d/mysql-x86_64.conf 
echo '/usr/local/mysql/lib' > /etc/ld.so.conf.d/mysql-5.6.conf
ldconfig 

/etc/init.d/mysqld restart

