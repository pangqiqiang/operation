#!/usr/bin/env python
# -*- coding:utf8 -*-
'''
handle redis for libray
usage 
'''

import redis
import sys

#配置信息
CONFIG = {
    "host" : "r-2ze8d3f29312a524.redis.rds.aliyuncs.com",
    "port" : "6379",
    "password": "xxxxxxxxxxxxxxxxxxx",
    "db": 5,
    "max_connections": 10
}



def del_keys_pre(redis_cli, pre, limit):
    count = 0
    all_count = 0
    #pipeline
    pipe = redis_cli.pipeline(transaction=False)
    for id in redis_cli.scan_iter(pre + "*", count=50000):
		count+=1
		all_count+=1
		deal_exception_pipe(pipe.delete, id, all_count)
		if count >= limit:
			deal_exception_pipe(pipe.execute, id, all_count)
			count = 0
    if count >0:
        deal_exception_pipe(pipe.execute, id, all_count)
    print("exec keys count:", all_count)

def del_keys_file(redis_cli, file, limit):
    count = 0
    all_count = 0
    #pipeline
    pipe = redis_cli.pipeline(transaction=False)
    with open(file) as fobj:
        for id in fobj:
            count+=1
            all_count+=1
            deal_exception_pipe(pipe.delete, id, all_count)
            if count >= limit:
                deal_exception_pipe(pipe.execute, id, all_count)
                count = 0
        if count >0:
            deal_exception_pipe(pipe.execute, id, all_count)
    print("exec keys count:", all_count)

def get_key(redis_cli, key):
    value = redis_cli.get(key)
    print(value)


def deal_exception_pipe(pipe_func, id, all_count):
    try:
        pipe_func(id)
    except Exception as e:
        print(str(e))
        print("exec keys:%s with key:%s" % all_count, id)
        sys.exit(2)

def usage():
    print("USAGE:", sys.argv[0], "action", "[args....]")


#主程序
if __name__ == "__main__":
	#建议函数对应hash
    funcs = {"del_by_pre": del_keys_pre, "del_by_file": del_keys_file, "get": get_key}
    #建立连接池
    try:
        if CONFIG["password"] != "":
            pool = redis.ConnectionPool(**CONFIG)
        else:
            del CONFIG["password"]
            pool = redis.ConnectionPool(**CONFIG)
    except Exception as e:
        print(str(e))
        sys.exit(1)
    #从连接池连接
    conn = redis.Redis(connection_pool=pool)
    if len(sys.argv) < 2:
        usage()
    else:
        action = sys.argv[1]
        action_func = funcs[action]
        if action == "del_by_pre" and len(sys.argv) == 2:
            print("Are Your Sure You Want to delete all keys[Y/N]")
            opt = raw_input().rstrip()
            if opt != "y" and  opt != "Y":
                sys.exit(0)
        elif action == "get":
            if len(sys.argv) == 2:
                print("a key must given")
                sys.exit(2)
            action_func(conn, sys.argv[2])
        else:
            if len(sys.argv) == 2:
                print("a key pre or file should be give")
                sys.exit(2)
            action_func(conn, sys.argv[2], 5000)