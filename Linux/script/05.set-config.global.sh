#!/bin/sh
set -e


# 增加最大打开文件句柄数量
echo 'ulimit -SHn 65535' >> /etc/rc.local


# VIM
cp -u ../config/.vimrc /root/
cp -u ../config/alias.custom.sh /etc/profile.d/
cp -u ../config/bashrc.custom.sh /etc/profile.d/

