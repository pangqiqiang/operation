#!/bin/bash
innodb_metric=$1
 
case $innodb_metric in
   Innodb_rows_locked)
                      value=$(echo "SELECT SUM(trx_rows_locked) AS rows_locked, SUM(trx_rows_modified) AS rows_modified, SUM(trx_lock_memory_bytes) AS lock_memory FROM information_schema.INNODB_TRX;"|mysql --defaults-file=/usr/local/zabbix/etc/.my.cnf -N| awk '{print $1}')
                      if [ "$value" == "NULL" ];then
                         echo 0
                      else
                         echo $value
                      fi
                    ;;
   Innodb_rows_modified)
                      value=$(echo "SELECT SUM(trx_rows_locked) AS rows_locked, SUM(trx_rows_modified) AS rows_modified, SUM(trx_lock_memory_bytes) AS lock_memory FROM information_schema.INNODB_TRX;"|mysql --defaults-file=/usr/local/zabbix/etc/.my.cnf -N| awk '{print $2}')
                      if [ "$value" == "NULL" ];then
                         echo 0
                      else
                         echo $value
                      fi
                    ;;
   Innodb_trx_lock_memory)
                      value=$(echo "SELECT SUM(trx_rows_locked) AS rows_locked, SUM(trx_rows_modified) AS rows_modified, SUM(trx_lock_memory_bytes) AS lock_memory FROM information_schema.INNODB_TRX;"|mysql --defaults-file=/usr/local/zabbix/etc/.my.cnf -N| awk '{print $3}')
                      if [ "$value" == "NULL" ];then
                         echo 0
                      else
                         echo $value
                      fi
                    ;;
       Innodb_trx_lock_wait)
                         value=$(echo 'SELECT LOWER(REPLACE(trx_state, " ", "_")) AS state, count(*) AS cnt from information_schema.INNODB_TRX GROUP BY state;'|mysql --defaults-file=/usr/local/zabbix/etc/.my.cnf -N|grep lock_wait|awk '{print $2}')
                         if [ "$value" == "" ];then
                            echo 0
                         else
                            echo $value
                         fi
                        ;;
                   *)
                    echo "wrong parameter"
                    ;;
 
esac