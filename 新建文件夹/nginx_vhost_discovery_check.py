#!/usr/bin/env python
#-*-coding:utf-8-*-
import os,re,json

def get_nginx_confs(path, pattern):
    config_files = []
    for root, dirpath, filename in os.walk(path):
        for file in filename:
            if (re.search(pattern, file)):
                config_files.append(os.path.join(root, file))
    return config_files

def get_vhost(filename, outfile):
    with open(filename, 'r') as fin:
        with open(outfile, 'a+') as fout:
            for line in fin:
                if re.match(r'^\s*#', line):
                    continue
                m = re.search(r'listen\s+([0-9]+);', line)
                if m: fout.write(m.group(1) + '\n')
                m = re.search(r'server_name\s+([a-zA-Z0-9.-]+);', line)
                if m: fout.write(m.group(1) + '\n')

def gen_discovery_json(file):
    base_dir = os.path.abspath(os.path.dirname(__file__))
    file_path = os.path.join(base_dir, file)
    data = {}
    vhosts = []
    with open(file_path, 'r') as fob:
        lines = fob.readlines()
        while True:
            try:
                server = lines.pop().strip()
                port = lines.pop().strip()
                vhost = {"{#vhost}": server + "|" + port}
                vhosts.append(vhost)
            except IndexError:
                break    
    data["data"] = vhosts
    jsonStr = json.dumps(data, sort_keys=True, indent=4)
    return jsonStr

if __name__ == "__main__":
    vhosts_config_dir = "/home/work/app/nginx/conf/vhosts"
    file_pattern = r'\.(com|cn|net|org)\.conf$'
    tmp_log = 'test.log'
    if os.path.isfile(tmp_log): os.remove(tmp_log)
    for file in get_nginx_confs(vhosts_config_dir , file_pattern):
        get_vhost(file, tmp_log)
    print(gen_discovery_json(tmp_log))