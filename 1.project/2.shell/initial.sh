#!/bin/bash
#
#
#####################################################################
#
#first lease was by wrrited by sptty .  mail: 747824617@qq.com
#   lease time Fri Mar  6 06:07:36 PST 2015
#
#Tue Aug 04 updated by sptty .  mail: 747824617@qq.com
#   
#thrid release was updated by sptty .  mail: 747824617@qq.com
#   lease time Fri Sep 15 10:35:05  PST 2015
#   split this initial script to many parts;
#   part1:basic setting
#   part2:security
#   part3:optimization
#   part4:monitor
#   part5: send an e-mail abort the excuted reslut to the administrator.
#
#####################################################################

#
# Source function library.
. /etc/init.d/functions

#
#define variable
    EMAIL_LISTS='wanhb_yg@yun-gui.com 15021477616@139.com'

#part1:basic setting
echo 'part1:basic setting' ;

#part1-1 shutdown NetworkMangeer,iptable,iptables  service 
echo 'part1-1 shutdown NetworkMangeer,iptable,iptables  service '
    
    /etc/init.d/NetworkManager stop
    chkconfig NetworkManager off
    
    /etc/init.d/iptables stop
    chkconfig iptables off
    chkconfig ip6iptables off
    chkconfig cups  off
    chkconfig postfix off

        sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
        echo 'setenforce 0'     >> /etc/rc.local
        echo -e "the selinux status is :`getenforce`"

        sed -i 's/id:5/id:3/g' /etc/inittab

#part1-2 set alias
echo 'part1-2 set alias'
    
        CDN='cd /etc/sysconfig/network-scripts/'
        echo -e  "alias cdn='cd /etc/sysconfig/network-scripts/' "  >> /etc/bashrc
		echo -e  "alias yumi='yum -y install' "  >> /etc/bashrc
        echo -e  "alias cdyum='cd /etc/yum.repos.d/' "  >> /etc/bashrc

#part1-3 set static network
echo 'part1-3 set static network and bonding bond1'

        sed -i 's/dhcp/static/g' /etc/sysconfig/network-scripts/ifcfg-eth0
        sed -i 's/ONBOOT=no/ONBOOT=yes/g' /etc/sysconfig/network-scripts/ifcfg-eth0
        sed -i 's/"ONBOOT=no"/"ONBOOT=yes"/g' /etc/sysconfig/network-scripts/ifcfg-eth0
		sed -i 's/IPV6INIT="yes"/IPV6INIT="no"/g' /etc/sysconfig/network-scripts/ifcfg-eth0
		sed -i 's/NM_CONTROLLED="yes"/NM_CONTROLLED="no"/g' /etc/sysconfig/network-scripts/ifcfg-eth0
        IP="`ifconfig eth0|grep 'inet addr' |cut -d':' -f2 |cut -d' ' -f1`"
        echo "IPADDR=$IP" >> /etc/sysconfig/network-scripts/ifcfg-eth0
        echo 'NETMASK=255.255.255.0' >> /etc/sysconfig/network-scripts/ifcfg-eth0
        echo 'GATEWAY=172.19.1.254' >> /etc/sysconfig/network-scripts/ifcfg-eth0
        echo 'DNS1=114.114.114.114' >> /etc/sysconfig/network-scripts/ifcfg-eth0
        echo 'DNS2=202.96.209.133' >> /etc/sysconfig/network-scripts/ifcfg-eth0
		cd /etc/sysconfig/network-scripts/;
        service network restart
#       cp -p ifcfg-eth0 ifcfg-eth0.initial
		
#part1-4 set backup IP 
#echo ' set backup IP '
#		cd /etc/sysconfig/network-scripts/
#		cp ifcfg-eth0 ifcfg-eth3
#		sed -i "s/172.19.1./172.19.101/g"  /etc/sysconfig/network-scripts/ifcfg-eth3
#		HWADDR=`grep eth3 /etc/udev/rules.d/70-persistent-net.rules |cut -d ',' -f4 |cut -d'"' -f2`
#		sed -i "s/HWADDR.*/HWADDR=$HWADDR/g" ifcfg-eth3
#		sed -i "/UUID/d" ifcfg-eth3
#		BACK_IP=`grep IPADDR ifcfg-eth3 |cut -d '=' -f2`

#part1-5 set network bonding 		
#echo ' set network bonding  '

#echo \
#"DEVICE="bond0"
#BOOTPROTO=static
#IPADDR=$IP 
#NETMASK=255.255.255.0
#NM_CONTROLLED="no"
#ASTER="yes"
#BOOT=yes
#YPE=Ethernet
#SERCTL=no
#ATEWAY=172.19.1.254
#NS1=114.114.114.114
#ONDING_OPTS="mode=1 miimon=100 primary=eth0"
#REFIX=24
#EFROUTE=yes
#PV4_FAILURE_FATAL=yes
#PV6INIT=no
#AME="System bond0" " \
#   	>> /etc/sysconfig/network-scripts/ifcfg-bond0
#   	
#cho \
#DEVICE=eth0
#OOTPROTO=none
#ASTER=bond0
#LAVE=yes" \
# /etc/sysconfig/network-scripts/ifcfg-eth0
#
#
#cho \
#DEVICE=eth1
#OOTPROTO=none
#ASTER=bond0
#LAVE=yes" \
# /etc/sysconfig/network-scripts/ifcfg-eth1 
#   	
#cho \
#alias bond0 bonding
#ptions bonding mode=0 miimon=200
# \
#> /etc/modprobe.d/bonding.conf
#odprobe bonding
#lsmod | grep bonding


mkdir -p  /root/scripts /backup

#part1-5 6 set /etc/hosts and hostname ,yum resource,time-server 
echo 'part1-5 6 set /etc/hosts and hostname ,yum resource,time-server '


rm -rf  /etc/hosts
wget -P /etc/ http://172.19.1.253/files/hosts

        export NODE_NUM=`echo $IP |cut -d'.' -f4`
        sed -i  '$d' /etc/sysconfig/network
        echo "HOSTNAME=node$NODE_NUM" >> /etc/sysconfig/network

 #set local yum server to aliyun.
        cd /etc/yum.repos.d/
        LS="`ls`" ;for i in $LS;do mv $i $i.bak ;done
        wget -P /etc/yum.repos.d/ http://172.19.1.253/files/epel-6.repo
	wget -P /etc/yum.repos.d/ http://172.19.1.253/files/Centos-6.repo
        yum clean all
        yum makecache
        yum -y install expect telnet  iptraf nethogs nload

        sleep 1

 #update time from time server
        echo '*/5 * * * * /usr/sbin/ntpdate -d pntp01 &>> /dev/null' |crontab
#part1-7 setting granting infomation

echo'part1-7 setting granting infomation'

echo '' > /etc/issue
echo '' > /etc/issue.net
echo '' > /etc/motd

echo -e '        \e[1;36m  # # # # # # # # #\e[0m'>> /etc/issue
echo -e '        \e[1;36m #                  \e[1;36m# \e[0m' >> /etc/issue
echo -e '        \e[1;36m #                    \e[1;36m# \e[0m' >> /etc/issue
echo -e '        \e[1;36m #      \e[1;33m ######        \e[1;36m#\e[0m' >>/etc/issue
echo -e '        \e[1;36m #      \e[1;33m########       \e[1;36m#    Welcome to  \e[0m'>> /etc/issue
echo -e '        \e[1;36m #     \e[1;33m##########      \e[1;36m#  \e[0m' >> /etc/issue
echo -e '        \e[1;36m #      \e[1;33m##########     \e[1;36m#\e[0m' >> /etc/issue
echo -e '        \e[1;36m #       \e[1;33m########      \e[1;36m#  Cloudbox System \e[0m'>> /etc/issue
echo -e '        \e[1;36m #       \e[1;33m ######       \e[1;36m# \e[0m' >> /etc/issue
echo -e '        \e[1;36m   #                   \e[1;36m# \e[0m' >> /etc/issue
echo -e '        \e[1;36m     #                 \e[1;36m# \e[0m' >> /etc/issue
echo -e '        \e[1;36m       # # # # # # # #   \e[0m' >> /etc/issue
echo ' ' >> /etc/issue
echo -e '\e[1;32m                 Any questions,please contact us. \e[0m' >> /etc/issue
#echo -e '\e[1;32m                            wanhb_yg@yun-gui.com  \e[0m' >> /etc/issue 
#echo -e '\e[1;32m                                     15021477616  \e[0m' >> /etc/issue
echo '  ' >>  /etc/issue
echo -e '\e[1;31m  warning: All operations on \\n would be monitored !!!\e[0m' >> /etc/issue
echo '  ' >>  /etc/issue


cat /etc/issue >> /etc/issue.net
cat /etc/issue >> /etc/motd
sed -i '1,$s/on \\n//g' /etc/motd


#part2 securiy setting
echo 'part2 security setting'
#part2-1  setting login backup system by key;
echo 'part2-1 setting login backup system by key;  '

/usr/bin/expect << EOF
spawn  ssh-keygen -t dsa
set timeout 3
expect "ssh-keygen -t dsa"
set timeout 3
send "\r"
expect "Enter"
set timeout 3
send "\r"
expect "Enter"
set timeout 3
send "\r"
expect "Enter"
set timeout 3
send "\r"
spawn ssh-copy-id -i /root/.ssh/id_dsa.pub 172.19.1.253
expect "yes"
set timeout 5
send "yes\r"
expect "passsword"
set timeout 10
send "yungui2015\r"
expect eof
EOF

scp root@172.19.1.253:/root/.ssh/id_dsa.pub /tmp/id_dsa.pub.$NODE_NUM

#mv /tmp/id_dsa.pub /tmp/id_dsa.pub
cat /tmp/id_dsa.pub.$NODE_NUM >> /root/.ssh/authorized_keys 
chmod 600 /root/.ssh/authorized_keys
rm -rf /tmp/id_dsa.pub.$NODE_NUM


cat /tmp/id_dsa.pub.NODE_NUM >> /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
rm -rf /tmp/id_dsa.pub.$NODE_NUM

	#the admin server to login those server will be setting in pkick01 useing nmap.


#part2-2 modify user key and  password to login
echo 'part2-2 modify user root allow to login by key and  password '
	sed -i '1,$s/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
	sed -i '1,$s/#AuthorizedKeysFile/AuthorizedKeysFile/g' /etc/ssh/sshd_config
	sed -i '1,$s/#GSSAPIAuthentication no/GSSAPIAuthentication no/g' /etc/ssh/sshd_config


#part2-3 midify use root only can login in local network 172.19.1.0/24
echo  'part2-3 midify use root only can login in local network 172.19.1.0/16'
	echo "sshd:172.19.1.0/24:allow" >> /etc/hosts.allow

#part2-4 setting single user password
echo 'part2-4 setting single user password'
	#this step was setted in kickstart file. default password is '你懂得'


#part2-5 install extundelete 
yum -y install gcc gcc++  lrzsz
#yum -y install tigervnc-server
yum -y install gcc gcc-c++ gcc-g77
yum install e2fsprogs-libs e2fsprogs-devel -y

wget -P /usr/local/src/ http://172.19.1.253/files/extundelete-0.2.4.tar.bz2
cd /usr/local/src/
tar xf extundelete-0.2.4.tar.bz2
cd  extundelete-0.2.4

./configure --prefix=/usr/local/extundelete  2>> /dev/null 
make  2>> /dev/null 
make install  2>> /dev/null
ln -s /usr/local/extundelete/bin/extundelete /usr/local/bin/extundelete

#part2-6 file encodeing

echo 'export   LC_ALL="zh_CN.GB2312"' >> /root/.bashrc


#part3 optimization
echo 'part3 optimization'

#part3-1 modify sysctl.conf 
echo 'part3-1 modify sysctl.conf '
	echo \
'#setting tcp rules
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.conf.default.rp_filter = 1
kernel.sysrq = 0
net.bridge.bridge-nf-call-ip6tables = 0
net.bridge.bridge-nf-call-iptables = 0
net.bridge.bridge-nf-call-arptables = 0
kernel.shmmax = 68719476736
kernel.shmall = 4294967296
kernel.shmmni = 4096
kernel.sem = 250 32000 100 128
fs.file-max = 6815744
net.core.rmem_default=262144
net.core.rmem_max=16777216
net.core.wmem_default=262144
net.core.wmem_max=16777216
fs.aio-max-nr=1048576
net.ipv4.icmp_echo_ignore_all = 0
net.ipv4.tcp_keepalive_time=1800
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 65536 16777216
net.ipv4.ip_local_port_range = 9000 65500
'>> /etc/sysctl.conf

echo '* - nofile 65535' >> /etc/security/limits.conf
sysctl -p 


#part3-2 set ssh service no use DNS 
        sed -i '1,$s/#UseDNS yes/UseDNS no/g'  /etc/ssh/sshd_config

#part3-3 set vim
    echo 'set autoindent' >> /root/.vimrc
    echo 'syntax on' >> /root/.vimrc
    
#part4  zabbix monitor  setting 
echo 'part4  zabbix monitor  setting '
    useradd  -s /sbin/nologin  zabbix
    wget -P /usr/local/src/ http://172.19.1.253/files/zabbix_agent.tar.gz
    cd /usr/local/src
    mkdir /usr/local/zabbix
    tar -zxvf zabbix_agent.tar.gz -C /usr/local/zabbix &>>/dev/null
    echo -e "zabbix-agent 10050/tcp #Zabbix Agent
zabbix-agent 10050/udp #Zabbix Agent 
zabbix_trip 10051/tcp" >> /etc/services
    mkdir /etc/zabbix
    cp /usr/local/zabbix/conf/zabbix_agentd.conf /etc/zabbix/
    cd /etc/zabbix/
    sed -i 's/Server=127.0.0.1/Server=pzabbix01/g' zabbix_agentd.conf
    sed -i "s/# Hostname=/Hostname=node$NODE_NUM/g" zabbix_agentd.conf
     sed -i "s/ServerActive=127.0.0.1/ServerActive=172.19.1.101/g" zabbix_agentd.conf
    echo '/usr/local/zabbix/sbin/zabbix_agentd start -c /etc/zabbix/zabbix_agentd.conf' >> /etc/rc.local
    #echo ' rm -rf /root/initial*' >> /etc/rc.local
    sleep 10

#part5 
#part5-1    e-mail the administrator the setting and configurating results .
echo "e-mail the administrator the setting and configurating results ."
    cat /root/initial.log  | mailx -s " node$NODE_NUM has error in setting."  $EMAIL_LISTS

#echo "Yvngvi@$HOSTNAME" |passwd --stdin
sleep 5

wget http://172.19.1.253/bonding.sh
sh bonding.sh

rm -rf /root/bonding.sh
rm -rf /root/initial.*
rm -rf /root/initial.log

#after installed,reboot the system 
reboot
exit 0
