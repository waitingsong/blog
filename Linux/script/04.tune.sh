#!/bin/bash
set -e


# 系统性能调整

#内核 TCP/IP、Socket参数调优

cat>>/etc/sysctl.conf<<EOF
net.core.rmem_max = 838860
net.core.somaxconn = 4096
net.core.wmem_max = 8388608
net.ipv4.ip_local_port_range = 10240 60999
net.ipv4.tcp_keepalive_intvl = 15
net.ipv4.tcp_keepalive_probes = 3
net.ipv4.tcp_keepalive_time = 600
net.ipv4.tcp_fin_timeout = 10
net.ipv4.tcp_max_syn_backlog = 4096
net.ipv4.tcp_max_tw_buckets = 65536
net.ipv4.tcp_retries1 = 3
net.ipv4.tcp_retries2 = 5
net.ipv4.tcp_rmem = 4096 87380 8388608
net.ipv4.tcp_syn_retries = 3
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_wmem = 4096 87380 8388608
EOF


# 开启 TCP BBR 算法
echo net.core.default_qdisc=fq >> /etc/sysctl.conf
echo net.ipv4.tcp_congestion_control=bbr >> /etc/sysctl.conf

# 验证是否成功启用了 TCP BBR
# sysctl net.ipv4.tcp_congestion_control
# sysctl net.ipv4.tcp_available_congestion_control
# 返回值应为：
# net.ipv4.tcp_available_congestion_control = cubic reno bbr

# sysctl net.core.default_qdisc
# 返回值应为：
# net.core.default_qdisc = fq

# lsmod | grep bbr
# 返回值有 tcp_bbr 模块即说明bbr已启动


sysctl -p
