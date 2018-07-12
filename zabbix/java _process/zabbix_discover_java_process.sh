#!/bin/bash

COMM=`/home/work/app/jdk/bin/jps | grep -iv jps | grep -E '.*\.(war|jar)'`
OLDIFS=$IFS
IFS="\n"
count=`echo $COMM| wc -l`
printf '{\n'
printf '\t"data":[\n'
mycount=1
echo "$COMM"|while read line;do
  IFS=$OLDIFS
  pairs=($line)
  if [ $count -eq $mycount ]; then
    printf "\t\t\t{\"{#PID}\":\"${pairs[0]}\",\"{#PNAME}\":\"${pairs[1]}\"}\n"
  else
    printf "\t\t\t{\"{#PID}\":\"${pairs[0]}\",\"{#PNAME}\":\"${pairs[1]}\"},\n"
    let "mycount++"
  fi
done 
printf '\t]\n'
printf '}\n'


