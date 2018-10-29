#!/bin/bash
INDICES=(
user_info
report_basic_info
gjj_info
shebao_info
mobile_bill_report
mobile_call_report
person_report
urgent_contact_report
urgent_contact_report_history
location_info_history
student_info_report
deliver_address_report
ebusiness_expense_report
ebusiness_contact_report
face_verify
face_verify_result
)

ADDR='http://10.111.30.171:9200/'
QUERY='/credit_data/_delete_by_query/'
BODY='{"query":{"match_all":{}}}'
#BODY='{"query":{"match":{"system_name":"JJD"}}}'

for index in ${INDICES[@]};do
  (curl -XPOST ${ADDR}${index}${QUERY} -d ${BODY} &> /dev/null)&
done
wait
echo "All index data has been cleared"
#增加刷新时间，不复制
setting_body='{"refresh_interval":"60s","number_of_replicas":0}'
for index in ${INDICES[@]};do
	(curl -XPUT ${ADDR}${index}/_settings -d  $setting_body &> /dev/null)&
done
wait
echo "All index configed ok!"

# 恢复索引复制和近实时刷新
# restore_body='{"refresh_interval":"1s","number_of_replicas":1}'
# for index in ${INDICES[@]};do
	# (curl -XPUT ${ADDR}${index}/_settings -d  $restore_body &> /dev/null)&
# done
# wait
# echo "All index restored ok!"