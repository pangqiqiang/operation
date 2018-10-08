#!/bin/bash
MONGO_PORT=$1
MONITOR_APPLICATION=$2
MONITOR_USER="clustermonitor"
MONITOR_PASS="password"
if [ $# -eq 2 ];then
  BASE_RESULT=$(echo "db.serverStatus()"|/home/work/app/mongodb/bin/mongo 127.0.0.1:${MONGO_PORT}/admin -u ${MONITOR_USER} -p ${MONITOR_PASS}|tail -n +3)
  shift
else
  BASE_RESULT=$(echo "db.serverStatus().${MONITOR_APPLICATION}"|/home/work/app/mongodb/bin/mongo 127.0.0.1:${MONGO_PORT}/admin -u ${MONITOR_USER} -p ${MONITOR_PASS}|tail -n +3)
  shift 2
fi
until [ $# -eq 0 ];do
    start_num=$(echo ${BASE_RESULT} | grep -bo $1|grep -Eo '[0-9]+'|head -1)
	BASE_RESULT=$(echo ${BASE_RESULT} | cut -b ${start_num}-)
	shift
done
result=$(echo $BASE_RESULT| awk -F':|,|}' '{print $2}'|sed -r 's/NumberLong\("?([0-9]+)"?\)/\1/')     
echo $result
