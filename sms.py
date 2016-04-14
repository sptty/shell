#!/usr/bin/python
# -*- coding: UTF-8 -*-
__author__ = 'sptty'


if __name__ == "__main__":

    import sys, math, os, urllib, json, urllib2, time, datetime

    # 1. 更新时间
    update_time = datetime.datetime.now()
    otherStyleTime = update_time.strftime("%Y/%m/%d %H:%M:%S")
    print otherStyleTime
    # print otherStyleTime

    # 联系人手机号码
    TELL = 150214776**
    print TELL
    # 更新包名称
    PKG_NAME = 'EboxCI.war,YGserver.jar'

    # 更新状态
    MESSAGE = u'更新成功,'

    SMS = PKG_NAME + '\n' + u'于' + otherStyleTime + '\n' + MESSAGE + u',请知晓.' + '\n' + u'<运维团队>'
    print SMS

    def http_post():
        import sys, math, os, urllib, json, urllib2, time, datetime
        url = 'http://wt.3tong.net/json/sms/Submit'
        values = {"account": "dhwew01", "password": "156f810bcsdsdsds5c4df425877", "msgid": "", "phones": TELL, "content": SMS, "sign": "【江苏**】", "subcode": "8528", "sendtime": "201405051230"}
        jdata = json.dumps(values)             # 对数据进行JSON格式化编码
        req = urllib2.Request(url, jdata)       # 生成页面请求的完整数据
        response = urllib2.urlopen(req)       # 发送页面请求
        return response.read()                    # 获取服务器返回的页面信息
    resp = http_post()
    print resp
