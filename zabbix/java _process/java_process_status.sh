#!/bin/bash
CAM=$2
PID=$1
KEY=$3
STATE_FILE="/home/work/app/zabbix/logs/monitor_logs/javastat_${CAM}_${PID}.log"
[ -d ${STATE_FILE%/*} ] || mkdir -p ${STATE_FILE%/*}
[ -f $STATE_FILE ] || touch $STATE_FILE

#判断文件生成时间是否为最近30s
last_gen_time=$(stat -c %Y $STATE_FILE)
exec_time=$(date +%s)
delt_time=$(( $exec_time - $last_gen_time))

if [ $delt_time -ge 30 ];then
	/home/work/app/jdk/bin/jstat -"$CAM" "$PID" > "${STATE_FILE}"
fi

function status() {
  header=`head -1 ${STATE_FILE}`
  values=`tail -1 ${STATE_FILE}`
  paras=($header)
  results=($values)
  count=${#paras[*]}
  for ((i=0;i<$count;i++));do
    if [ ${paras[$i]} = $KEY ];then
      echo ${results[$i]}
      exit 0;
    fi
  done
 echo "invalid paras"
}

status
