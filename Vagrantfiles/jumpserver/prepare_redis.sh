#!/bin/bash

#!/bin/bash
#添加dns为114.114.114.114
#sudo sed -i '/^nameserver/cnameserver 114.114.114.114' /etc/resolv.conf
#更新阿里yum源
sudo rm -rf /etc/yum.repos.d/*.repo
sudo curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo > /dev/null 2>&1
sudo curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo > /dev/null 2>&1
sudo sed -i '/mirrors.aliyuncs.com/d'  /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/epel.repo
sudo sed -i '/mirrors.cloud.aliyuncs.com/d'  /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/epel.repo
sudo yum makecache

#安装redis
sudo yum install -y redis

#不设置密码
sudo sed -i "s#bind 127.0.0.1#bind $1#g" /etc/redis.conf
echo "maxmemory-policy allkeys-lru" >> /etc/redis.conf

sudo systemctl start redis
sudo systemctl enable redis > /dev/null 2>&1