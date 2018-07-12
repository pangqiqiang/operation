#!/bin/bash
#记录域名与ip对应文件，格式url,ip
servername="$1"
ip="$2"
query_ip=$(dig -t A "${servername}" +time=3 +short | grep -w ${ip})
if [[ -n "${query_ip}" ]]; then
  echo 0
else
  echo 1
fi
  
  
