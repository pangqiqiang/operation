#!/bin/bash

#更新阿里yum源
sudo rm -rf /etc/yum.repos.d/*.repo
sudo curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
sudo curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
sudo yum makecache
#安装mariadb
sudo yum install -y mariadb mariadb-server mariadb-devel
sudo systemctl start mariadb
sudo systemctl enable mariadb
#修改配置
sudo sed 
###初始化数据库
sudo mysqladmin -u root -p password "$1"
mysql -uroot -p"$1" -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$1' WITH GRANT"
mysql -uroot -p"$1" <<-SQL
create database jumpserver default charset 'utf8' collate 'utf8_bin';
grant all on jumpserver.* to 'jumpserver'@'192.168.100.%' identified by $2;
flush privileges;
SQL