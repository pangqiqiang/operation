#!/bin/bash

ids_dir='/home/mongo_to_es'
ssh root@10.111.33.190 "cd ${ids_dir}&&cp ids.db ids.db1&&mv ids.db ids.db.bak"
scp 10.111.33.190:${ids_dir}/ids.db1 /home
ssh root@10.111.33.191 "cd ${ids_dir}&&cp ids.db ids.db2&&mv ids.db ids.db.bak"
scp 10.111.33.191:${ids_dir}/ids.db2 /home
ssh root@10.111.33.192 "cd ${ids_dir}&&cp ids.db ids.db3&&mv ids.db ids.db.bak"
scp 10.111.33.192:${ids_dir}/ids.db3 /home


cd /home
sqlite3 ids.db1 ".dump" > ids.db1.sql
sqlite3 ids.db2 ".dump" > ids.db2.sql
sqlite3 ids.db3 ".dump" > ids.db3.sql


sed -rn  '/INSERT|BEGIN|COMMIT/p' ids.db1.sql > ids.db001.sql
sed -rn  '/INSERT|BEGIN|COMMIT/p' ids.db2.sql > ids.db002.sql
sed -rn  '/INSERT|BEGIN|COMMIT/p' ids.db3.sql > ids.db003.sql

mv mongo_to_es/ids.db .
sqlite3 ids.db ".read ids.db001.sql"
sqlite3 ids.db ".read ids.db002.sql"
sqlite3 ids.db ".read ids.db003.sql"

mv ids.db mongo_to_es/
cd mongo_to_es
scp ids.db root@10.111.33.190:/home/mongo_to_es
scp ids.db root@10.111.33.191:/home/mongo_to_es
scp ids.db root@10.111.33.192:/home/mongo_to_es

