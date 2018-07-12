#!/bin/bash
PASS="TeNSXaGXbMz8eY86"
HOST="127.0.0.1"
cli_path='/home/work/app/redis/bin/redis-cli'
res=(`sudo ss -tulnp|grep -iw redis|awk '{print $(NF-2)}'|awk -F':' '{print $(NF)}'|sort -u`)
for i in $(seq 0 $[${#res[@]}-1]);do
	role=$(echo "Info" | $cli_path  -h ${HOST} -p ${res[$i]} -a $PASS | grep 'role' | awk -F: '{print $2}')
	if [[ $role !=  "slave" ]];then
		unset res[$i]
	fi
done

count=${#res[@]}
if [ $count -eq 0 ];then
    exit 2
fi
printf '{\n'
printf '\t"data":[\n'
mycount=1
for line in ${res[@]};do
    if [ $count -eq $mycount ];then
        printf "\t\t\t{\"{#SLAVEPORT}\":\"$line\"}\n"
    else
        printf "\t\t\t{\"{#SLAVEPORT}\":\"$line\"},\n"
        let "mycount++"
    fi
done 

printf '\t]\n'
printf '}\n'
exit 0
