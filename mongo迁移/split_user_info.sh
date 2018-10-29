#!/bin/bash

input_file='/mnt3/user_info.json'

lines_count=`wc -l ${input_file} | awk '{print $1}'`
slices=4
each_file_row=$(($lines_count / $slices + 1))
each_tiny_row=$(($each_file_row / 10 + 1))

cd /mnt3
split -l ${each_file_row} ${input_file} -d -a 3 user_info

if [ `ls user_info[0-9]* | wc -l` -eq 4 ];then
	scp user_info000 root@10.111.33.189:/home
	ssh root@10.111.33.189 "cd /home&&split -l $each_tiny_row user_info000 -d -a 3 user_info_&&mv user_info_* /home/mongo_to_es"
	scp user_info001 root@10.111.33.190:/home
	ssh root@10.111.33.190 "cd /home&&split -l $each_tiny_row user_info001 -d -a 3 user_info_&&mv user_info_* /home/mongo_to_es"
	scp user_info002 root@10.111.33.191:/home
	ssh root@10.111.33.191 "cd /home&&split -l $each_tiny_row user_info002 -d -a 3 user_info_&&mv user_info_* /home/mongo_to_es"
	scp user_info003 root@10.111.33.192:/home
	ssh root@10.111.33.192 "cd /home&&split -l $each_tiny_row user_info003 -d -a 3 user_info_&&mv user_info_* /home/mongo_to_es"
fi


