#!/bin/bash
#
#
#####################################################################
#
#first lease was by wrrited by sptty .  mail: 747824617@qq.com
#   lease time Fri Oct  28  PST 2015
#desciprtion:
#automaticing install tomcat web server  by shell script.
#####################################################################

#
# Source function library.
. /etc/rc.d/init.d/functions
 
# Source networking configuration.
. /etc/sysconfig/network
 
# Check that networking is up.
#[ "$NETWORKING" = "no" ] && exit 0

#yum  -y groupinstall 'Compatibility libraries' 'Development tools'
yum -y install pcre-devel  bzip2-devel  openssl-devel  >> /dev/null  && echo 'yum success......' || echo 'yum failed ' 
yum -y install libmcrypt-devel  mhash-devel libevent-devel \
 mcrypt-devel libcurl-devel >> /dev/null && echo 'yum success......' || echo 'yum failed ' 

#install jdk 
wget -P /root/ http://172.19.1.253/jdk.sh
cd /root/
sh jdk.sh
rm -rf jdk.sh

#install tomcat
wget -P /usr/local/src/ http://172.19.1.253/files/apache-tomcat-7.0.65.tar.gz

#[ ! -d  /usr/local/tomcat ] && mkdir /usr/local/tomcat   

cd /usr/local/src/

tar xf apache-tomcat-7.0.65.tar.gz -C /usr/local/

mv  /usr/local/apache-tomcat-7.0.65  /usr/local/tomcat

cd /usr/local/tomcat

cp bin/catalina.sh  /etc/init.d/tomcat

sed -i '2a\# chkconfig: 2345 63 37 '  /etc/init.d/tomcat
sed -i '3a\# description: tomcat server init script ' /etc/init.d/tomcat

chkconfig --add tomcat
chkconfig tomcat on

sed -i '4a\JAVA_HOME=/usr/local/jdk1.7.0_79  ' /etc/init.d/tomcat
sed -i '5a\CATALINA_HOME=/usr/local/tomcat' /etc/init.d/tomcat


#add user and roles

sed  '/^<tomcat-users>/a\#<user username="admin" password="yungui2015" roles="manager-gui,manager-script,manager-jmx,manager-status"/>' /usr/local/tomcat/conf/tomcat-users.xml
sed  '/^<tomcat-users>/a\#<user username="role1" password="yungui2015" roles="role1"/>'  /usr/local/tomcat/conf/tomcat-users.xml 
sed  '/^<tomcat-users>/a\#<user username="both" password="yungui2015" roles="tomcat,role1"/>'   /usr/local/tomcat/conf/tomcat-users.xml 
sed  '/^<tomcat-users>/a\#<user username="tomcat" password="yungui2015" roles="tomcat"/>'    /usr/local/tomcat/conf/tomcat-users.xml 
sed  '/^<tomcat-users>/a\#<role rolename="manager-status"/>' /usr/local/tomcat/conf/tomcat-users.xml 
sed  '/^<tomcat-users>/a\#<role rolename="manager-jmx"/>' /usr/local/tomcat/conf/tomcat-users.xml  
sed  '/^<tomcat-users>/a\#<role rolename="manager-script"/>' /usr/local/tomcat/conf/tomcat-users.xml                                      
sed  '/^<tomcat-users>/a\#<role rolename="manager-gui"/>' /usr/local/tomcat/conf/tomcat-users.xml 
sed  '/^<tomcat-users>/a\#<role rolename="role1"/>' /usr/local/tomcat/conf/tomcat-users.xml 
sed  '/^<tomcat-users>/a\#<role rolename="tomcat"/>' /usr/local/tomcat/conf/tomcat-users.xml

/etc/init.d/tomcat start

rm -rf /root/$0

exit 0
