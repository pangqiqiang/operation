#!/bin/bash
res=(`sudo ss -tulnp|grep -iw mysqld|awk '{print $(NF-2)}'|awk -F':' '{print $(NF)}'|sort -u`)
for i in $(seq 0 $[${#res[@]}-1]);do
	echo "show slave status \G" | /home/work/app/mysql/bin/mysql -h 127.0.0.1 -P ${res[$i]} | grep -q '.'
	if [[ $? -ne 0 ]];then
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
        printf "\t\t\t{\"{#VALUE}\":\"$line\"}\n"
    else
        printf "\t\t\t{\"{#VALUE}\":\"$line\"},\n"
        let "mycount++"
    fi
done 

printf '\t]\n'
printf '}\n'
exit 0
