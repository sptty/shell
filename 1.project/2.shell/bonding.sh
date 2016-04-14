#!/bin/bash
#
#
#####################################################################
#
#first lease was wrrited by sptty .  mail: 747824617@qq.comn Fri Oct 21 06:07:36 PST 2015
#   bonding network em1 and em2 
#
#####################################################################


#part1-5 set network bonding 
echo ' set network bonding  '


cd /etc/sysconfig/network-scripts/

IP=`ifconfig em1 |grep 'inet addr:'|cut -d':' -f2 |cut -d' ' -f1`

echo \
"DEVICE="bond0"
BOOTPROTO=static
IPADDR=$IP 
NETMASK=255.255.255.0
NM_CONTROLLED="no"
MASTER="yes"
ONBOOT=yes
TYPE=Ethernet
USERCTL=no
GATEWAY=172.19.1.254
DNS1=202.96.209.133
DNS2=114.114.114.114
BONDING_OPTS=\"mode=1 miimon=100 primary=em1\"
PREFIX=24
PEFROUTE=yes
IPV4_FAILURE_FATAL=yes
IPV6INIT=no ">> /etc/sysconfig/network-scripts/ifcfg-bond0

echo \
'DEVICE=em1
BOOTPROTO=none
MASTER=bond0
SLAVE=yes '> /etc/sysconfig/network-scripts/ifcfg-em1


echo \
'DEVICE=em3
BOOTPROTO=none
MASTER=bond0
SLAVE=yes' > /etc/sysconfig/network-scripts/ifcfg-em3
   
echo \
'alias bond0 bonding
options bonding mode=1 miimon=200' > /etc/modprobe.d/bonding.conf
modprobe bonding
lsmod | grep bonding

/etc/init.d/network restart

rm -rf /root/$0

exit 0
