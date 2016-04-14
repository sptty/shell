#!/bin/bash
#
#author: sptty
#  mail: 747824617@qq.com
#date the Dec  8  18:42:11 CST 2015
#automic update OPMP by shell
#


if [ `id -nu` != 'root' ];then
	echo -e "\033[31mYou do not have permission to excute $0 \033[0m"
	exit 9
fi


#define variabler 

DATE=`date +%F_%H:%M`
#PKG_PATH=/usr/local/apache-tomcat-7.0.55/webapps
PKG_PATH=/usr/local/tomcat/webapps
BACKUP_PATH=/backup
PKG_NAME=OPMP

# 判断是否已经将更新的包上传，否则退出		

if ! ls /update/${PKG_NAME}.war &>> /dev/null;then

        echo -e "\033[31mPackage ${PKG_NAME}.war not found in directory /update \033[0m"

        echo -e "\033[31mPlease upload Package ${PKG_NAME}.war to directory /update  ,then excute : sh $0 again.\033[0m"

        exit 8
fi


# 停止tomcat

TOMCAT_PID=`ps -ef |(grep -v grep |(grep 'tomcat' |(awk '{print $2}')))`
kill -9 ${TOMCAT_PID}  &&   echo -e "\033[31mtomcat stop successed\033[0m" || exit 77


# /etc/init.d/tomcat stop  &>> /dev/null 
# sleep 2
# /etc/init.d/tomcat stop  &>> /dev/null 
# sleep 2
# /etc/init.d/tomcat stop &>> /dev/null &&   echo -e "\033[31mtomcat stop successed\033[0m" || exit 77


#备份OPMP文件夹及文件

if [ `ps -ef |( grep -v 'grep' | ( grep 'tomcat'|(wc -l)))` -eq 0 ];then

	ls $BACKUP_PATH/${PKG_NAME} &>> /dev/null || mkdir  -p $BACKUP_PATH/${PKG_NAME}
	
	cd $PKG_PATH
	
	tar --force-local -zcf ${PKG_NAME}.${DATE}.tar.gz ${PKG_NAME}.war ${PKG_NAME}  && rm -rf ${PKG_NAME}.war ${PKG_NAME} && mv ${PKG_NAME}.${DATE}.tar.gz $BACKUP_PATH/${PKG_NAME}/

	mv /update/${PKG_NAME}.war $PKG_PATH
fi


# 启动tomcat

if [ `ps -ef |( grep -v 'grep' | ( grep 'tomcat'|(wc -l)))` -eq 0 ];then

	/etc/init.d/tomcat start &>> /dev/null &&   echo -e "\033[31mtomcat start successed\033[0m"
fi


# 检查tomcat是否启动成功

if [ `ps -ef |( grep -v 'grep' | ( grep 'tomcat'|(wc -l)))` -eq 1 ];then

	 echo -e "\033[31mPackage ${PKG_NAME}.war update successed\033[0m"
	 exit 8
else
	 echo -e "\033[31mPackage ${PKG_NAME}.war update failed\033[0m"
	exit 0
fi


