# -*- coding: UTF-8 -*-
__author__ = 'admin'

for num in range(1,200):
    j = 3
    for i in range(2,num):
        if num%i == 0:
            j = num/i
            #print '%d = %d * %d' %(num,i,j)
            break
    else:
        print num,u'是一个质数'
        fo =open(u'D:\PC\desktop\python\质数.txt','a+')
        fo.write(str(num)+'是一个质数')
        fo.write('\n')

