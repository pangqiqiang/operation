#!/bin/bash
# 主机地址/IP
MYSQL_HOST='127.0.0.1'
# 端口
MYSQL_PORT=$1
 
# 数据连接
MYSQL_CONN="/home/work/app/mysql/bin/mysqladmin -h${MYSQL_HOST} -P${MYSQL_PORT}"
 
# 参数是否正确
if [ $# -ne 2 ];then 
    echo "arg error!" 
fi 
 
# 获取数据
case $2 in 
    Uptime) 
        result=`${MYSQL_CONN} status|cut -f2 -d":"|cut -f1 -d"T"` 
        echo $result 
        ;;
    Aborted_clients)
	result=`${MYSQL_CONN} extended-status | grep -w 'Aborted_clients'|cut -d "|" -f3`
	echo ${result}
	;; 
    Com_update) 
        result=`${MYSQL_CONN} extended-status |grep -w "Com_update"|cut -d"|" -f3` 
        echo $result 
        ;; 
    Slow_queries) 
        result=`${MYSQL_CONN} status |cut -f5 -d":"|cut -f1 -d"O"` 
        echo $result 
        ;; 
    Com_select) 
        result=`${MYSQL_CONN} extended-status |grep -w "Com_select"|cut -d"|" -f3` 
        echo $result 
                ;; 
    Com_rollback) 
        result=`${MYSQL_CONN} extended-status |grep -w "Com_rollback"|cut -d"|" -f3` 
                echo $result 
                ;; 
    Questions) 
        result=`${MYSQL_CONN} status|cut -f4 -d":"|cut -f1 -d"S"` 
                echo $result 
                ;; 
    Com_insert) 
        result=`${MYSQL_CONN} extended-status |grep -w "Com_insert"|cut -d"|" -f3` 
                echo $result 
                ;; 
    Com_delete) 
        result=`${MYSQL_CONN} extended-status |grep -w "Com_delete"|cut -d"|" -f3` 
                echo $result 
                ;; 
    Com_commit) 
        result=`${MYSQL_CONN} extended-status |grep -w "Com_commit"|cut -d"|" -f3` 
                echo $result 
                ;; 
    Bytes_sent) 
        result=`${MYSQL_CONN} extended-status |grep -w "Bytes_sent" |cut -d"|" -f3` 
                echo $result 
                ;; 
    Bytes_received) 
        result=`${MYSQL_CONN} extended-status |grep -w "Bytes_received" |cut -d"|" -f3` 
                echo $result 
                ;; 
    Com_begin) 
        result=`${MYSQL_CONN} extended-status |grep -w "Com_begin"|cut -d"|" -f3` 
                echo $result 
                ;;           
    max_connections) 
        result=`echo "show variables like '%max_connections%'"|/home/work/app/mysql/bin/mysql -h $MYSQL_HOST -P $MYSQL_PORT |grep -iw "max_connections"|awk '{print $2}'` 
                echo $result 
                ;;           
    current_processes) 
        result=`echo "show full processlist"|/home/work/app/mysql/bin/mysql -h $MYSQL_HOST -P $MYSQL_PORT |wc -l` 
                echo $(($result - 2)) 
                ;;           
   Threads_connected) 
	result=`${MYSQL_CONN} extended-status |grep -w "Threads_connected"|cut -d"|" -f3`
                echo $result
                ;;           
        *) 
        echo "PARAMETERS ERROR" 
        ;; 
esac
