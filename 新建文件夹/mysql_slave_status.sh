#/bin/bash
### MySQL Slave Information
MYSQL_CONN="/usr/bin/mysqladmin -u${MYSQL_USER} -p${MYSQL_PWD} -h${MYSQL_HOST} -P${MYSQL_PORT} show slave status\G"


case $2 in
	Seconds_Behind_Master)
		result = echo $MYSQL_CONN |grep "Seconds_Behind_Master"|awk '{print $2}'
		echo $result
	;;
	Slave_IO_Running)
		result = echo $MYSQL_CONN |grep "Slave_IO_Running"|awk '{print $2}'
		echo $result
	;;
	Slave_SQL_Running)
		result = echo $MYSQL_CONN |grep "Slave_SQL_Running"|awk '{print $2}'
		echo $result
	;;
	Seconds_Behind_Master)		
		result = echo $MYSQL_CONN |grep "Seconds_Behind_Master"|awk '{print $2}'
		echo $result
	;;	
	Relay_Log_Pos)
		result = echo $MYSQL_CONN |grep "Relay_Log_Pos"|awk '{print $2}'
		echo $result
	;;
	Exec_Master_Log_Pos)
		result = echo $MYSQL_CONN |grep "Exec_Master_Log_Pos"|awk '{print $2}'
		echo $result
	;;
	Read_Master_Log_Pos)		
		result = echo $MYSQL_CONN |grep "Read_Master_Log_Pos"|awk '{print $2}'
		echo $result
	;;			
    *) 
        echo "paramers error" 
    ;; 
esac			
			
			
			
