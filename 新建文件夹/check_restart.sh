#!/bin/bash
time_pat="[0-9]+-[0-9]+-[0-9]+ [0-9]+:[0-9]+:[0-9]+"
error_pat="ERROR - abandon connection"
while true; do
	error_n=`tail -100 /data/weblogs/api/catalina.out  | grep -i "$error_pat"|wc -l`
  error_time=`tail -100 /data/weblogs/api/catalina.out  | grep -i "$error_pat" | grep -Eo "$time_pat"`
	if [ $error_n -gt 0 ] && [ "$error_time" \<= "$error_time_old" ]; then
    echo ##########`date +%F`############ >>  connect_error.log
    tail -100 /data/weblogs/api/catalina.out >> connect_error.log
		sh /home/ecloud/bin/api/restartApi.sh
	fi
  error_time_old=$error_time
	sleep 5	
done