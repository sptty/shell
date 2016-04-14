#!/bin/bash
#
########################################################
#author: sptty
#  mail: 747824617@qq.com
#date Fri Dec 25 14:57:49 CST 2015
#automic add copy bachuped file to backup server 
########################################################


#1.	先检查备份的路径是否存在,不存在新建,存在继续!	
#
#2. 先检查服务器是不是备份完成了,没有完成,记录日志到log,进行下一台主机的备份
#								 完成备份,拷贝当日备份文件
#											拷贝完成,删除原有1周前的备份
#											拷贝失败,记录日志到log
#
#3. 如果log不为空,则发送报警邮件给管理员!~~~
#


if [ `id -nu` != 'root' ];then
	echo -e "\033[31mYou do not have permission to excute $0 \033[0m"
	exit 9
fi


function send_mail(){


}



#define variabler 
DATE_TODAY=`date +%F`
DATE_WEEK_AGO=`date -d "7 days ago" +%F`
BACKUP_PATH=/backup
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


done < host	#保存所有需要备份的服务器.

#添加完成之后,通过backup-server连接所有终端,并输入yes完成最后一步.

	
