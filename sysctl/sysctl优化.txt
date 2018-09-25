#!/bin/bash

echo -e "\e[1;32mset Timezone......\e[0m"
dpkg-reconfigure tzdata

echo -e "\e[1;32mrestart services......\e[0m"
service rsyslog restart
service cron restart

grep 65536 -q /etc/profile && profile=1
if ((profile!=1));then
echo -e "\e[1;32mset ulimit to 65536......\e[0m"
echo 'ulimit -SHn 65536' >> /etc/profile
tail /etc/profile
fi

grep "net.core.rmem_max=16777216" -q /etc/sysctl.conf && sysctl=1
if ((sysctl!=1));then
echo -e "\e[1;32moptimize kernal params......\e[0m"
echo '
net.ipv4.ip_local_port_range = 1024 65000
net.core.rmem_max=16777216
net.core.wmem_max=16777216
net.core.somaxconn = 65535
net.core.netdev_max_backlog = 262144
net.ipv4.tcp_max_orphans = 262144
net.ipv4.tcp_max_syn_backlog = 262144
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_max_tw_buckets = 100000
net.ipv4.tcp_keepalive_time = 1800
net.ipv4.tcp_rmem=4096 87380 16777216
net.ipv4.tcp_wmem=4096 65536 16777216
net.ipv4.tcp_synack_retries = 3
net.ipv4.tcp_syn_retries = 3' >> /etc/sysctl.conf
tail /etc/sysctl.conf -n 20
sysctl -p
fi

grep "nofile 65536" -q /etc/security/limits.conf && limits=1
if ((limits!=1));then
echo -e "\e[1;32mset nofile to 65536......\e[0m"
sed -i -e 's|^# End of file|* - nofile 65536\n\n# End of file|g' /etc/security/limits.conf
fi

echo -e "\e[1;32mset hostname......\e[0m"
echo -n "hostname:"
read host
hostname $host
echo $host > /etc/hostname
cat /etc/hostname