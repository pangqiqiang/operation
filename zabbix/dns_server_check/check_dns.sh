#!/bin/bash
#记录域名与ip对应文件，格式url,ip
servernames_file="servernames.txt"
#记录原始的分隔符
OLD_IFS=${IFS}
#循环文件
while read line;do
  IFS=","
  name_pairs=(${line})
  url=${name_pairs[0]}
  query_ip=$(dig -t A "${url}" +time=3 +short | grep ${name_pairs[1]})
  if [[ -n "${query_ip}" ]]; then
    IFS=${OLD_IFS}
    continue
  else
    echo "${url}"
    exit 1
  fi
done<${servernames_file}
echo 0
  
