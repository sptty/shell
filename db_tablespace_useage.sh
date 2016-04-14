#!/bin/bash
#

#########################################

#write by sptty wan     date 20150818
#       first release

#check database tablespace useage 
##########################################




. ~/.bash_profile

#define variables;


#mail list 
EMAIL_LIST1="wanhb_yg@yun-gui.com  sunyh_yg@yun-gui.com"

if [ ! -f /tmp/db_tablespace_useage.log ];then
        touch /tmp/db_tablespace_useage.log;
fi

# amount of connection 
sqlplus -S "/ as sysdba" << EOF
spool  /tmp/db_tablespace_useage.log;
SELECT tbs table_name,
sum(usedM)/sum(totalM)*100 used_Percent
FROM(
SELECT b.file_id ID,
b.tablespace_name tbs,
b.file_name name,
b.bytes/1024/1024 totalM,
(b.bytes-sum(nvl(a.bytes,0)))/1024/1024 usedM,
sum(nvl(a.bytes,0)/1024/1024) remainedM,
sum(nvl(a.bytes,0)/(b.bytes)*100),
(100 - (sum(nvl(a.bytes,0))/(b.bytes)*100))
FROM dba_free_space a,dba_data_files b
WHERE a.file_id = b.file_id
GROUP BY b.tablespace_name,b.file_name,b.file_id,b.bytes
ORDER BY b.tablespace_name)
GROUP BY tbs;
spool off;
exit;
EOF


#conect useages of databaes!!
USED_PERCENT=`cat /tmp/db_tablespace_useage.log  |grep -E -v 'TABLE_NAME|^$|grep|-' |awk -F' ' '{print $2}' |sort -n|tail -1|cut -d '.' -f1`



#sending a  email to administrator if the useage of database tablespace is 80%

if [ `echo $USED_PERCENT` -gt 80 ];then 
        echo -e  "the useage of database tablespace is $USED_PERCENT% \t\nPlease add datafile !!\t\nYun-gui.com administrator "|mailx -s "`date` db_tablespace_useage Status" $EMAIL_LIST1 
fi

if [ -f /tmp/db_tablespace_useage.log ];then
	rm -rf /tmp/db_tablespace_useage.log 
fi


exit 0;
