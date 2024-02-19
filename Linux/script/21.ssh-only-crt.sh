#!/bin/bash


# 设置服务器**仅**接受ssh公钥登录（可选）
# **确认以上操作成功并且成功使用公钥登录系统后继续下面操作**

cp /etc/ssh/sshd_config /etc/ssh/ori_sshd_config
sed -i "s/^\s*\(PasswordAuthentication.*\)/# \1/" /etc/ssh/sshd_config
echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config

