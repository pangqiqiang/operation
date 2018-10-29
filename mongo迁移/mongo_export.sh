#nohup /usr/bin/mongoexport -h 127.0.0.1 --port 18000 -u trans   -p 123456   -d credit -c c_user  -f _id,l_report_contact_list --type=json -o /mnt3/mobile_call_report.json &> /tmp/mobile_call.log&

#nohup /usr/bin/mongoexport -h 127.0.0.1 --port 18000 -u trans   -p 123456   -d credit -c c_user  -q '{"c_base_info.t_mobile_upd_tm":{$gt:ISODate("2018-10-20T13:00:00Z")}}' -f _id,l_report_contact_list --type=json -o /mnt3/mobile_call_report1.json &> /tmp/mobile_call.log&

nohup /usr/bin/mongoexport -h 127.0.0.1 --port 18000 -u trans   -p 123456   -d credit -c c_user  -f _id,l_business_system,c_base_info --type=json -o /mnt3/user_info.json &> /tmp/user_info.log&

nohup /usr/bin/mongoexport -h 127.0.0.1 --port 18000 -u trans   -p 123456   -d credit -c c_user  -f _id,l_business_system,c_base_info,c_car_info,c_earn_info,c_house_info,c_job_info,c_recent_location_info,c_gjj_info,c_shebao_info --type=json -o /mnt3/report_basic_info.json &> /tmp/report_basic_info.log&

nohup /usr/bin/mongoexport -h 127.0.0.1 --port 18000 -u trans   -p 123456   -d credit -c c_user  -f _id,c_gjj_info --type=json -o /mnt3/gjj_info.json &> /tmp/gjj_info.log&

nohup /usr/bin/mongoexport -h 127.0.0.1 --port 18000 -u trans   -p 123456   -d credit -c c_user  -f _id,c_shebao_info --type=json -o /mnt3/shebao_info.json &> /tmp/shebao_info.log&

nohup /usr/bin/mongoexport -h 127.0.0.1 --port 18000 -u trans   -p 123456   -d credit -c c_user  -f _id,l_mobile_bill --type=json -o /mnt3/mobile_bill_report.json &> /tmp/mobile_bill.log&

nohup /usr/bin/mongoexport -h 127.0.0.1 --port 18000 -u trans   -p 123456   -d credit -c c_user  -f _id,c_report_person --type=json -o /mnt3/person_report.json &> /tmp/person_report.log&

nohup /usr/bin/mongoexport -h 127.0.0.1 --port 18000 -u trans   -p 123456   -d credit -c c_user  -f _id,l_report_base_contract --type=json -o /mnt3/urgent_contact_report.json &> /tmp/urgent_concat.log&

nohup /usr/bin/mongoexport -h 127.0.0.1 --port 18000 -u trans   -p 123456   -d credit -c c_user_data  -f _id,l_base_info_history --type=json -o /mnt3/urgent_contact_report_history.json &> /tmp/urgent_concat_history.log&

nohup /usr/bin/mongoexport -h 127.0.0.1 --port 18000 -u trans   -p 123456   -d credit -c C_user_data_locations  -f _id,l_user_locations --type=json -o /mnt3/location_info_history.json &> /tmp/location_info_history.log&

nohup /usr/bin/mongoexport -h 127.0.0.1 --port 18000 -u trans   -p 123456   -d credit -c c_user  -f _id,l_report_xuexin --type=json -o /mnt3/StudentInfo.json &> /tmp/studentinfo.log&

nohup /usr/bin/mongoexport -h 127.0.0.1 --port 18000 -u trans   -p 123456   -d credit -c c_user  -f _id,l_report_deliver_address --type=json -o /mnt3/deliver_address_report.json &>/tmp/deliver_address.log&

nohup /usr/bin/mongoexport -h 127.0.0.1 --port 18000 -u trans   -p 123456   -d credit -c c_user  -f _id,l_report_ebusiness_expense --type=json -o /mnt3/EbusinessExpense.json &> /tmp/EbusinessExpense.log&

nohup /usr/bin/mongoexport -h 127.0.0.1 --port 18000 -u trans   -p 123456   -d credit -c c_user  -f _id,l_report_collection_contact --type=json -o /mnt3/EbusinessContact.json &> /tmp/EbusinessContact.log&

#mysql -h10.111.33.181 -umysqltords jjd -p -e 'select * from t_face_verify' > /mnt3/t_face_verify.txt 

#mysql -h10.111.33.181 -umysqltords jjd -p -e 'select * from t_face_verify_result' > /mnt3/t_face_verify_result.txt









