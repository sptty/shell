# -*- coding: UTF-8 -*-
__author__ = 'admin'

import os
try:
   fh = open('D:\PC\desktop\python\\aAa.log', "a+")
   fh.write("This is my test file for exception handling!!\n\n")
except IOError:
   print 'Error: can\'t find file or read data'
else:
   print "Written content in the file successfully"
   fh.close()


j = 3