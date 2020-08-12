#!/bin/bash

sudo mkdir /srv/jumpserver
sudo cp -a /vagrant/* /srv/jumpserver
#sudo chown -R vagrant:vagrant /srv/jumpserver
## 设置yum的阿里云源
sudo rm -rf /etc/yum.repos.d/*.repo
sudo curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
#sudo sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-Base.repo
sudo curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
sudo yum makecache

## 安装依赖包
sudo yum install -y python36 python36-devel python36-pip \
             libtiff-devel libjpeg-devel libzip-devel freetype-devel \
         lcms2-devel libwebp-devel tcl-devel tk-devel sshpass \
         openldap-devel mariadb-devel mysql-devel libffi-devel \
         openssh-clients telnet openldap-clients gcc


## 配置pip阿里云源
mkdir /home/vagrant/.pip
cat << EOF | sudo tee -a /home/vagrant/.pip/pip.conf
[global]
timeout = 6000
index-url = https://mirrors.aliyun.com/pypi/simple/

[install]
use-mirrors = true
mirrors = https://mirrors.aliyun.com/pypi/simple/
trusted-host=mirrors.aliyun.com
EOF

##配置python环境
python3.6 -m venv /home/vagrant/venv
source /home/vagrant/venv/bin/activate
echo 'source /home/vagrant/venv/bin/activate' >> /home/vagrant/.bash_profile
sudo yum install -y $(cat /vagrant/requirements/rpm_requirements.txt)
pip3 install wheel
pip3 install --upgrade pip setuptools
pip3 install -r /vagrant/requirements/requirements.txt
#####配置jms########
cp /srv/jumpserver/config_example.yml /srv/jumpserver/config.yml
sed -i "s#SECRET_KEY:#SECRET_KEY: `cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 49`#g" /srv/jumpserver/config.yml
sed -i "s/BOOTSTRAP_TOKEN:/BOOTSTRAP_TOKEN: $1/g" /srv/jumpserver/config.yml
sed -i "s/DB_HOST: 127.0.0.1/DB_HOST: $2/g" /srv/jumpserver/config.yml
sed -i "s/REDIS_HOST: 127.0.0.1/REDIS_HOST: $3/g" /srv/jumpserver/config.yml
sed -i "s#CORE_HOST:#CORE_HOST: http://$4:8080#g" /srv/jumpserver/kokodir/config.yml
sed -i "s/BOOTSTRAP_TOKEN:/BOOTSTRAP_TOKEN: $1/g" /srv/jumpserver/kokodir/config.yml