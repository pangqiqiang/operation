#!/bin/bash
res=`sudo ss -tulnp|grep redis|grep -v 28107|awk '{print $(NF-2)}'|awk -F':' '{print $(NF)}'|sort -u`
count=`echo "$res"|wc -l`
if [ $count -eq 0 ];then
    echo "mysql has not find"
    exit 2
fi
printf '{\n'
printf '\t"data":[\n'
mycount=1
echo "$res"|while read line;do
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
