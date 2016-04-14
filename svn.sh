#!/bin/bash
#
#
#####################################################################
#
#first lease was by wrrited by sptty .  mail: 747824617@qq.com
#   lease time Fri Nov  25  PST 2015
#desciprtion:
#install svn server by shell.
#####################################################################

#test



#install httpd first!

wget -P /root/ http://172.19.1.253/httpd.sh
sh httpd.sh 


#install svn 

wget -P /usr/local/src/ http://172.19.1.253/files/subversion-1.9.2.tar.bz2

cd /usr/local/src/

tar xf subversion-1.9.2.tar.bz2
cd subversion-1.9.2

wget http://172.19.1.253/files/sqlite-amalgamation-3071501.zip

unzip sqlite-amalgamation-3071501.zip

mv sqlite-amalgamation-3071501 sqlite-amalgamation



subversion-1.9.2.tar.bz2  sqlite-amalgamation-3071501.zip 


./configure --prefix=/usr/local/svn --with-apxs=/usr/local/apache/bin/apxs    \
  --with-apr=/usr/local/apr --with-apr-util=/usr/local/apr-util  
  --with-openssl=/usr/include/openssl --with-zlib=/usr/local/lib \
  --enable-broken-httpd-auth 1>> /dev/null
echo $?

make && make install  && echo "svn is installed successed " 

if [ $? -ie 0 ];then 
	echo "svn  installed failed " 
	exit 8;
fi 


#test  svn 

cd /usr/local/svn/

./bin/svnserve --version && echo "svn is  OK! " 


#add svn bin path to  PATH env.
echo  "PATH=$PATH:/usr/local/svn/bin/" >> /etc/profile
source /etc/profile


#create svn directory

mkdir -p /svn/test

svnadmin create /svn/test

cd /svn/test

sed -i  '/^# anon-access/a\anon-access = none' conf/svnserve.conf 
sed -i  '/^# auth-access/a\auth-access = write' conf/svnserve.conf 
sed -i  '/^# password-db/a\password-db = passwd' conf/svnserve.conf 
sed -i  '/^# authz-dba\authz-db = authz' conf/svnserve.conf 
sed -i  "/^# realm/a\ realm = `pwd |cut -d/ -f2`" conf/svnserve.conf 


#add svn user

sed -i '/\/foo\/bar/a\test = rw' conf/authz

sed -i '/\/foo\/bar/a\\[\/\]' conf/authz

sed -i '/^\[users\]/a\ test = test' conf/passwd


echo '#!/bin/bash
#

# chkconfig:   345 85 15
# description: svn

# write by sptty on 2015-11-26 .
# contact info: 747824617@qq.com
#build this file in /etc/init.d/svn
#you client can access by URL below  
#	svn://IP:9999/test   user/passwd : test/test

# chmod 755 /etc/init.d/svn
# centos?¿?????????????????svn: service svn start(restart/stop)
SVN_HOME=/svn
if [ ! -f "/usr/local/svn/bin/svnserve" ]
then
echo "svnserver startup: cannot start"
exit
fi
case "$1" in
start)
echo "Starting svnserve..."
/usr/local/svn/bin/svnserve -d --listen-port 9999 -r $SVN_HOME
echo "Finished!"
;;
stop)
echo "Stoping svnserve..."
killall svnserve
echo "Finished!"
;;
restart)
$0 stop
$0 start
;;
*)
echo "Usage: svn { start | stop | restart } "
exit 1
esac' > /etc/init.d/svn

chmod +x /etc/init.d/svn
chkconfig --add svn

/etc/init.d/svn restart

rm -rf /root/$0

exit 0
