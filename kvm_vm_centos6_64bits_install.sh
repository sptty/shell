#!/bin/bash
#
########################################################
#author: sptty
#  mail: 747824617@qq.com
#date Tue Jan  5 14:22:26 EST 2016
#automic add kvm virtual  server by shell 
########################################################


if [ ! -f host ];then
	echo -e "\033[31mplease touch a file named host, and input the host name into it!\033[0m"
	if [ `wc -l host &>> /dev/null` -eq 0 ];then
		echo -e "please input the hostname into this file,one hostname on line "
		echo -e "example: \nvm01\nvm02"
		exit 8
	fi 
	exit 9
fi



#define variabler 

while read HOST;do

mkdir -p  /kvm/${HOST}

virt-install --name ${HOST} --ram=2048 --vcpus=2  --os-variant=rhel6  --disk=/kvm/${HOST}/${HOST}.qcow2,size=50,format=qcow2,bus=virtio –-keymap=en-us     --location=http://10.1.166.20/cobbler/ks_mirror/centos-6.7_64/ --extra-args="ks=http://10.1.166.20/ks.6.7.cfg"   --bridge=virbr0,model=virtio 

sheep 5 

done < host


rm -rf host && touch host
#添加完成之后,通过backup-server连接所有终端,并输入yes完成最后一步.