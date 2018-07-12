#!/bin/bash
FUNC=$1
RD_PORT=$2
OPT=$3
RD_HOST='127.0.0.1'
RD_BIN_PATH='/home/work/app/redis/bin/redis-cli'
PASS='TeNSXaGXbMz8eY86'
declare -A CONFS
CONFS=(['6379']='/home/work/app/redis/redis.conf')

function perf(){
  result=`echo "info" | ${RD_BIN_PATH} -h ${RD_HOST} -p ${RD_PORT} -a ${PASS}|grep -iw ${OPT} | awk -F: '{print $NF}'`
  echo $result
}

function dbsize(){
   result=`echo "dbsize" | ${RD_BIN_PATH} -h ${RD_HOST} -p ${RD_PORT} -a ${PASS}|grep -Eo [0-9]+`
   echo $result
} 

function ping(){
   result=`echo "ping" | ${RD_BIN_PATH} -h ${RD_HOST} -p ${RD_PORT} -a ${PASS}`
   echo $result | grep -iq 'pong'
   [[ $? -eq 0 ]] && echo 1 || echo 0
} 

function conf(){
   result=`grep -E '^[^#]maxmemory' ${CONFS[$RD_PORT]}|grep -o [0-9]+`
   [[ -z $result ]] && result=0
   echo $result
} 
$FUNC
