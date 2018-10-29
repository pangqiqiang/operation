#!/bin/bash

input_file='/mnt3/mobile_call_report.json'

#lines_count=`wc -l ${input_file} | awk '{print $1}'`
#lines_count=`awk '{count++}END{print count}' ${input_file}`
lines_count=1650000
slices=4
each_file_row=$(($lines_count / $slices + 1))
each_tiny_row=$(($each_file_row / 10 + 1))

cd /mnt3
split -l ${each_file_row} ${input_file} -d -a 3 mobile_call_report

if [ `ls mobile_call_report[0-9]* | wc -l` -eq 4 ];then
	scp mobile_call_report000 root@10.111.33.189:/home
	ssh root@10.111.33.189 "cd /home&&split -l $each_tiny_row mobile_call_report000 -d -a 3 'mobile_call_report_' && mv mobile_call_report_* /home/mongo_to_es"
	scp mobile_call_report001 root@10.111.33.190:/home
	ssh root@10.111.33.190 "cd /home&&split -l $each_tiny_row mobile_call_report001 -d -a 3 'mobile_call_report_' && mv mobile_call_report_* /home/mongo_to_es"
	scp mobile_call_report002 root@10.111.33.191:/home
	ssh root@10.111.33.191 "cd /home&&split -l $each_tiny_row mobile_call_report002 -d -a 3 'mobile_call_report_' && mv mobile_call_report_* /home/mongo_to_es"
	scp mobile_call_report003 root@10.111.33.192:/home
	ssh root@10.111.33.192 "cd /home&&split -l $each_tiny_row mobile_call_report003 -d -a 3 'mobile_call_report_' && mv mobile_call_report_* /home/mongo_to_es"
fi