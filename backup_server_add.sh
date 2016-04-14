#!/bin/bash
#
########################################################
#author: sptty
#  mail: 747824617@qq.com
#date Fri Dec 25 14:57:49 CST 2015
#automic add bachup server ssh-key to all servers 
########################################################


if [ `id -nu` != 'root' ];then
	echo -e "\033[31mYou do not have permission to excute $0 \033[0m"
	exit 9
fi


#define variabler 

BACKUP_SERVER_IP=172.19.1.201
TMP_PATH=/tmp
PUBLIC_KEY_PATH=/root/.ssh
PUBLIC_KEY_NAME=id_dsa.pub


while read HOST;do

	#copy client ssh-key to backup sever and test !

	
	scp $HOST:$PUBLIC_KEY_PATH/$PUBLIC_KEY_NAME  $TMP_PATH/

	ssh-copy-id -i $TMP_PATH/$PUBLIC_KEY_NAME $BACKUP_SERVER_IP

	ssh-copy-id -i $TMP_PATH/$PUBLIC_KEY_NAME $BACKUP_SERVER_IP

	rm -f ${TMP_PATH}/${PUBLIC_KEY_NAME}

	#copy backup server ssh-key to client sever and test !
	
	scp $BACKUP_SERVER_IP:$PUBLIC_KEY_PATH/$PUBLIC_KEY_NAME  $TMP_PATH/
	
	ssh-copy-id -i $TMP_PATH/$PUBLIC_KEY_NAME $HOST
	
	rm -f ${TMP_PATH}/${PUBLIC_KEY_NAME}


done < host

#添加完成之后,通过backup-server连接所有终端,并输入yes完成最后一步.