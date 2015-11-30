# -*- coding: UTF-8 -*-
__author__ = 'admin'

import sys,math,os
import module1

j = 3
i = 2


j = 3
i = 2

for i in range(2, 100):
    x = 'foo'
    if i % 2 == 1:
        sys.stdout.write(x + '\n' + str(i) + x)
        module1.printname(x)
        i += 1
    else:
        sys.stdout.write(x + '\n' + str(i))
        i += 1



