#!/bin/bash
#
#author: sptty
#  mail: 747824617@qq.com
#date the Dec  8  18:42:11 CST 2015
#automic update EboxCI by shell
#


if [ `id -nu` != 'root' ];then
	echo -e "\033[31mYou do not have permission to excute $0 \033[0m"
	exit 9
fi


#define variabler 

DATE=`date +%F_%H:%M`
#PKG_PATH=/usr/local/apache-smsserver-7.0.55/webapps
PKG_PATH=/usr/local/YGserver
BACKUP_PATH=/backup
PKG_NAME=smsserver


# 判断是否已经将更新的包上传，否则退出		

if ! ls /update/${PKG_NAME}.jar &>> /dev/null;then

        echo -e "\033[31mPackage ${PKG_NAME}.jar not found in directory /update \033[0m"

        echo -e "\033[31mPlease upload Package ${PKG_NAME}.jar to directory /update  ,then excute : sh $0 again.\033[0m"

        exit 8
fi


# 停止 $PKG_NAME.jar

PKG_PID=`ps -ef |grep -v grep |grep smsserver.jar |awk '{print $2}'`

kill -9 $PKG_PID &&  echo -e "\033[31msmsserver stop successed\033[0m" || exit 77


sleep 3

#备份$PKG_NAME文件

if [ `ps -ef |( grep -v 'grep' | ( grep 'smsserver.jar'|(wc -l)))` -eq 0 ];then

	ls $BACKUP_PATH/${PKG_NAME} &>> /dev/null || mkdir  -p $BACKUP_PATH/${PKG_NAME}
	
	cd $PKG_PATH
	
	mv ${PKG_NAME}.jar $BACKUP_PATH/${PKG_NAME}/${PKG_NAME}.${DATE}

	mv /update/${PKG_NAME}*.jar $PKG_PATH

	sleep 3

	# 启动$PKG_NAME.jar

	cd $PKG_PATH
	
	sh sms.sh  && echo -e "\033[31msmsserver start successed\033[0m" 
else
	echo -e "\033[31mPackage ${PKG_NAME}.jar update failed\033[0m"
	
	exit 999
fi


# 检查$PKG_NAME.jar是否启动成功

if [ `ps -ef |( grep -v 'grep' | ( grep 'smsserver.jar'|(wc -l)))` -eq 1 ];then

	 echo -e "\033[31mPackage ${PKG_NAME}.jar update successed\033[0m"
	 exit 8
else
	 echo -e "\033[31mPackage ${PKG_NAME}.jar update failed\033[0m"
	exit 0
fi
