#!/bin/bash
#
#
#####################################################################
#
#first lease was by wrrited by sptty .  mail: 747824617@qq.com
#   lease time Fri Mar  6 06:07:36 PST 2015
#
#Tue Aug 04 updated by sptty .  mail: 747824617@qq.com


IP=`ifconfig em1 |grep 'inet addr:'|cut -d':' -f2 |cut -d' ' -f1`

cp -p ifcfg-em1 ifcfg-em1.initial

#part1-4 set backup IP 
echo ' set backup IP '
       cd /etc/sysconfig/network-scripts/
       cp ifcfg-em1 ifcfg-eth3
       sed -i "s/172.19.1./172.19.101/g"
       /etc/sysconfig/network-scripts/ifcfg-eth3
       HWADDR=`grep eth3 /etc/udev/rules.d/70-persistent-net.rules |cut -d ','
       -f4 |cut -d'"' -f2`
       sed -i "s/HWADDR.*/HWADDR=$HWADDR/g" ifcfg-eth3
       sed -i "/UUID/d" ifcfg-eth3
       BACK_IP=`grep IPADDR ifcfg-eth3 |cut -d '=' -f2`

