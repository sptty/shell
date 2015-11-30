# -*- coding:utf-8 -*-
__author__ = 'sptty'

import re,os,time,sys
reload(sys)
sys.setdefaultencoding('utf-8')

# -获取所有文件列表
filename = os.listdir("D:\\PC\\desktop\\kaoqin\\file\\")
print filename
for i in filename:  # 打开一个文件
    i = unicode(i, "utf-8")
    f = open("D:\\PC\\desktop\\kaoqin\\file\\"+'\\'+i, 'r')

    while True:

        l = f.readline()  # 读取文件的每一行
        if 'events' in l:
            # key = re.compile('title')
            # l_new = key.sub("\n"+i, l)
            l = l.replace('title', '\n'+i)
            fp_all = open("D:\PC\desktop\\kaoqin\\log\\all.log", 'a+')
            # fp = open("D:\PC\desktop\\kaoqin\\log\\"+i+".log", 'a+')

            # fp.write(l)         # 写入一个日志文件
            # l = unicode(l, "")
            fp_all.write(l)     # 写入一个总的日志文件
            fp_all.close()
            # fp.close()
            break

    f.close()


# 替换无用的字符
alllog = open("D:\PC\desktop\\kaoqin\\log\\all.log", 'r')                # 打开所有日志文件
alllog_new = open("D:\PC\desktop\\kaoqin\\log\\all_new.log", 'w+')       # 替换无用字符后的日志文件

readlog = alllog.readlines()                                             # 读取日志文件的每一行
for s in readlog:                                                        # 每一行匹配并替换

    # for j in ['start:', 'end:', "'", '},', '.html', '.htm', 'events: [', '{']:   # 需要替换的字符
    for j in ['start:', 'end:', "'", '},', '.html', '.htm', '{']:   # 需要替换的字符
        s = s.replace(j, '')
    alllog_new.write(s)                                                 # 替换后的一行写入到新文件


alllog.close()
alllog_new.close()