#!/bin/sh
set -e


# 增加最大打开文件句柄数量
echo 'ulimit -SHn 65535' >> /etc/rc.local


# VIM
cp ../config/.vimrc /root/


cp ../config/bashrc.custom /etc/
echo "source /etc/bashrc.custom" >> /etc/bashrc

