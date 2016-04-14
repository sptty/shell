#!/bin/bash
#
#author: sptty
#  mail: 747824617@qq.com
#date the Dec  8  18:42:11 CST 2015
#automic update php02 code by shell
#


if [ `id -nu` != 'root' ];then
	echo -e "\033[31mYou do not have permission to excute $0 \033[0m"
	exit 9
fi





#define variabler 
DATE=`date +%F_%H:%M`
UPDATE_PATH='/update'
PKG_PATH='/var/www/html/'
BACKUP_PATH='/backup'
UNAME=`ls -ld ${PKG_PATH} |awk '{print $3}'`
GNAME=`ls -ld ${PKG_PATH} |awk '{print $4}'`


# �ж��Ƿ��Ѿ������µİ��ϴ��������˳�		

cd ${UPDATE_PATH}

PKG_NAME=`ls|awk -F'.' '{print $1}'`

PKG_NUM=`ls|wc -l`


#û�и����ļ����˳�.

if [ `echo ${PKG_NUM}` -eq 0 ];then

	echo "there is no file to update..."
	
	exit 0 
	
fi


#/update���ļ�����ʼ����

if [ `echo $PKG_NUM` -nq 0 ];then
	for i in ${PKG_NAME};do
		
		ls ${BACKUP_PATH}/${i} &>> /dev/null || mkdir -p ${BACKUP_PATH}/${i} 
		
		cd ${PKG_PATH};
		
		tar --force-local -zcf ${BACKUP_PATH}/${i}/${i}.${DATE}.tar.gz  ${i}
		
		if ls ${BACKUP_PATH}/${i}/${i}.${DATE}.tar.gz &>> /dev/null;then
		
			unizp -o ${UPDATE_PATH}/${i}.zip -d ${PKG_PATH}/${i}
			
			chown -R ${UNAME}.${UNAME} ${PKG_PATH}/${i}
		
			mv ${UPDATE_PATH}/${i}.zip ${BACKUP_PATH}/${i}/patch.${i}.${DATE}.zip
			
		fi
		
	done
fi