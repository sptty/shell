#!/bin/bash
#
#author: sptty
#  mail: 747824617@qq.com
#date the Dec  18  18:42:11 CST 2015
#automic update Java code by shell
#


if [ `id -nu` != 'root' ];then
	echo -e "\033[31mYou do not have permission to excute $0 \033[0m"
	exit 9
fi


#define variabler 

UPDATE='/update'

# �ж��Ƿ��Ѿ������µİ��ϴ��������˳�		


cd $$UPDATE

PKG_NAME=`ls|awk -F'.' '{print $1}'`

PKG_NUM=`ls|wc -l`


#û�и����ļ����˳�.

if [ `echo $PKG_NUM` -eq 0 ];then
	echo "there is no file to update..."
	exit 0 
fi


#�и����ļ����ýű�.

if [ `echo $PKG_NUM` -nq 0 ];then
	for i in $PKG_NAME;do
		sh ${i}_update.sh && echo "$i update successed!!"
		sleep 10
	done
fi