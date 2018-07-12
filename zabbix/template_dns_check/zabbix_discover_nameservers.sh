#!/bin/bash
File="/home/work/app/zabbix/bin/scripts/servernames.txt"
OLDIFS=$IFS
count=`cat $File | wc -l`
printf '{\n'
printf '\t"data":[\n'
mycount=1
while read line;do
  IFS=','
  pairs=($line)
  IFS=$OLDIFS
  if [ $count -eq $mycount ]; then
    printf "\t\t\t{\"{#SERVER}\":\"${pairs[0]}\",\"{#IP}\":\"${pairs[1]}\"}\n"
  else
    printf "\t\t\t{\"{#SERVER}\":\"${pairs[0]}\",\"{#IP}\":\"${pairs[1]}\"},\n"
    let "mycount++"
  fi
done < "${File}"
printf '\t]\n'
printf '}\n'


