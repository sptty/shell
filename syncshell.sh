#!/bin/bash
#
#
#####################################################################
#
#first lease was by wrrited by sptty .  
#mail: 747824617@qq.com
#   lease time Fri Oct  26  PST 2015
#desciprtion:
#automaticing sync local shell to  script.
# you can add this shell to you crontab like this:
# * *   */6 *   * /bin/bash /var/www/html/syncshell.sh &>> /dev/null
#####################################################################


svn='/usr/bin/svn'


svn update /svn/shell/  >   /tmp/svn_update.log


#if no file change  .just  exit

[ `wc -l /tmp/svn_update.log|cut -d' ' -f1` -eq 1 ] && echo ' no file change ' && exit 8


###update file

if [ `grep -E '^\<U\>|^\<G\>' /tmp/svn_update.log  |wc -l` -eq 0 ];then
	echo ' no file update '
else
	UPDATE_FILE=` cat  /tmp/svn_update.log |grep -E '^\<U\>|^\<G\>'|grep --color=auto '\.sh$'|grep -v 'revision'|awk -F' ' '{print $2}'`
	for i in $UPDATE_FILE;do
		j=`basename $i`;
		mv /var/www/html/$j /backup/shell/$j.`date +%F-%H:%M`
		cp $i /var/www/html/
	done
fi 



###new  file

if [ `grep '^\<A\>' /tmp/svn_update.log  |wc -l` -eq 0 ] ;then 
	echo ' no file add'
else
	NEW_FILE=` cat  /tmp/svn_update.log |grep '^A'|grep --color=auto '\.sh$'| awk -F' ' '{print $2}'`
	for i in $NEW_FILE;do
		cp $i /var/www/html/
	done
fi

rm -rf /tmp/svn_update.log

exit 0
