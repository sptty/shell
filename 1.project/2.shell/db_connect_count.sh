#!/bin/bash
#

#########################################

#write by sptty wan     date 20150810
#       first release

#updated by Sptty Wan   date 20150811
#       added function : spliting log  and  sending mails.

#debug: by Sptty wan    date 20150813
#       the system will keep sending email after alarmed. 

#update log file to a ducument
#       move old log file to a document!!!
##########################################




. ~/.bash_profile

#define variables;
LOG_PATH=/home/oracle/scripts
TMP_LOG_PATH=/home/oracle/scripts
LOG_NAME=db_connect_count.log;
TMP_LOG_NAME=db_connect_count.tmp.log


#mail list 
EMAIL_LIST="wanhb_yg@yun-gui.com"  


if [ ! -f $LOG_PATH/$LOG_NAME ];then
        touch $LOG_PATH/$LOG_NAME;
fi;

date +%F-%H:%M:%S >> $LOG_PATH/$LOG_NAME ;


# amount of connection 
sqlplus -S "/ as sysdba" << EOF
spool  /home/oracle/scripts/db_connect_count.tmp.log ;
select count(*) from V\$session ;
select count(*) from v\$session where status='ACTIVE';
spool off;
exit;
EOF


#logging the number to the  log file 
cat  $TMP_LOG_PATH/$TMP_LOG_NAME  >> $LOG_PATH/$LOG_NAME ;
rm -rf  $TMP_LOG_PATH/$TMP_LOG_NAME ;



#sending a  email to administrator if the numbers of connection is lager than the 200 or limits ;


db_connect_count=`grep '[[:space:]]\{1,\}' $LOG_PATH/$LOG_NAME |grep -v COUNT |grep -v '-' |uniq |sort -un |tail -1`

if [ $db_connect_count -gt 180 ];then
        echo -e "DB connection is more than $db_connect_count\t\nPlease be careful .  \t\nSptty Wan\t\nYun-gui.com administrator "|mailx -s "`date` database_connection
Status" $EMAIL_LIST

mv $LOG_PATH/$LOG_NAME  $LOG_PATH/logs/$LOG_NAME.`date +%F-%H:%M` ;
fi




# split log file 

DAY_OF_WEEK=`date +%u`
DAY_OF_TIME=`date +%k%M`

if [ $DAY_OF_WEEK -eq 1 ] && [ $DAY_OF_TIME -eq 1010 ] ;then  
        mv $LOG_PATH/$LOG_NAME  $LOG_PATH/logs/$LOG_NAME.`date +%F` ;
fi  


exit 0;
