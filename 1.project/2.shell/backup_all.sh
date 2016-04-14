#!/bin/bash
#
########################################################
#author: sptty
#  mail: 747824617@qq.com
#date Fri Dec 25 14:57:49 CST 2015
#automic add copy bachuped file to backup server 
########################################################


#1.	�ȼ�鱸�ݵ�·���Ƿ����,�������½�,���ڼ���!	
#
#2. �ȼ��������ǲ��Ǳ��������,û�����,��¼��־��log,������һ̨�����ı���
#								 ��ɱ���,�������ձ����ļ�
#											�������,ɾ��ԭ��1��ǰ�ı���
#											����ʧ��,��¼��־��log
#
#3. ���log��Ϊ��,���ͱ����ʼ�������Ա!~~~
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


done < host	#����������Ҫ���ݵķ�����.

#������֮��,ͨ��backup-server���������ն�,������yes������һ��.

	
