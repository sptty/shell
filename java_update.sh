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

# 判断是否已经将更新的包上传，否则退出		


cd $$UPDATE

PKG_NAME=`ls|awk -F'.' '{print $1}'`

PKG_NUM=`ls|wc -l`


#没有更新文件就退出.

if [ `echo $PKG_NUM` -eq 0 ];then
	echo "there is no file to update..."
	exit 0 
fi


#有更新文件调用脚本.

if [ `echo $PKG_NUM` -nq 0 ];then
	for i in $PKG_NAME;do
		sh ${i}_update.sh && echo "$i update successed!!"
		sleep 10
	done
fi