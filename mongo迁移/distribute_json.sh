#!/bin/bash

files_to_189=(
deliver_address_report.json
shebao_info.json
t_face_verify.txt
EbusinessContact.json
)

files_to_190=(
location_info_history.json
person_report.json
mobile_bill_report.json
)

files_to_191=(
urgent_contact_report_history.json
EbusinessExpense.json
report_basic_info.json
)

files_to_192=(
StudentInfo.json
urgent_contact_report.json
gjj_info.json
t_face_verify_result.txt
)

for file in ${files_to_189[@]};do
	scp $file root@10.111.33.189:/home/mongo_to_es
done

for file in ${files_to_190[@]};do
	scp $file root@10.111.33.190:/home/mongo_to_es
done

for file in ${files_to_191[@]};do
	scp $file root@10.111.33.191:/home/mongo_to_es
done

for file in ${files_to_192[@]};do
	scp $file root@10.111.33.192:/home/mongo_to_es
done