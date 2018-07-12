#!/usrb/bin/env python
#-*-coding:utf-8-*-

import sys
import os
import pycurl
import time
import tempfile
import json


def discovery():
    base_dir = os.path.abspath(os.path.dirname(__file__))
    file_path = os.path.join(base_dir, "web_sites.txt")
    data = {}
    webs = []
    with open(file_path, 'r') as fob:
        for web_site in fob:
            web_site = web_site.strip()
            web = {"{#VALUE}": web_site}
            webs.append(web)
    data["data"] = webs
    jsonStr = json.dumps(data, sort_keys=True, indent=4)
    return jsonStr


def get_web(URL=None, INF=None):
    RESULT_DICT = {}
    if URL and INF:
        c = pycurl.Curl()
        c.setopt(pycurl.URL, URL)
        c.setopt(pycurl.CONNECTTIMEOUT, 5)  # 连接超时
        c.setopt(pycurl.TIMEOUT, 5)  # 请求超时
        c.setopt(pycurl.NOPROGRESS, 1)  # 屏蔽进度条
        c.setopt(pycurl.FORBID_REUSE, 1)  # 完成操作后强制断开连接
        c.setopt(pycurl.MAXREDIRS, 5)  # 最大重定向次数
        c.setopt(pycurl.DNS_CACHE_TIMEOUT, 0)  # dns缓存时间
        temp_file = tempfile.TemporaryFile()  # 用于临时缓存文件
        c.setopt(pycurl.WRITEHEADER, temp_file)
        c.setopt(pycurl.WRITEDATA, temp_file)
        try:
            c.perform()
            RESULT_DICT["CODE"] = c.getinfo(pycurl.HTTP_CODE)
            RESULT_DICT["DNS"] = c.getinfo(pycurl.NAMELOOKUP_TIME) * 1000
            RESULT_DICT["CONNECT"] = c.getinfo(pycurl.PRETRANSFER_TIME) * 1000
            RESULT_DICT["START"] = c.getinfo(pycurl.STARTTRANSFER_TIME) * 1000
            RESULT_DICT["REDIRECT"] = c.getinfo(pycurl.REDIRECT_TIME) * 1000
            RESULT_DICT["DOWNSPEED"] = c.getinfo(pycurl.SPEED_DOWNLOAD)
            RESULT_DICT["RESPONSE"] = c.getinfo(pycurl.TOTAL_TIME) * 1000
        except exception as e:
            print("connection err: " + str(e))
        finally:
            temp_file.close()
            c.close()
        return RESULT_DICT.get(INF)
    else:
        print("url and opt needed")


if __name__ == "__main__":
    if sys.argv[1].strip().lower() == "discovery":
        print(discovery())
        sys.exit()
    url = sys.argv[1]
    inf = sys.argv[2]
    print(get_web(url, inf))
