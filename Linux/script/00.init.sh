#!/bin/sh
set -e


dnf install -y wget curl langpacks-zh_CN langpacks-en langpacks-en_GB pwgen


dnf remove -y firewalld python-firewall firewalld-filesystem ntp \
  selinux-policy \
  docker \
  docker-client \
  docker-client-latest \
  docker-common \
  docker-latest \
  docker-latest-logrotate \
  docker-logrotate \
  docker-engine

echo '
LANG="en_US.UTF-8"
LC_TIME="en_US.UTF-8"
LC_MESSAGES="en_US.UTF-8"
SUPPORTED="zh_CN.UTF-8:zh_CN.GB18030:zh_CN:zh:en_US.UTF-8:en_US:en"
SYSFONT="latarcyrheb-sun16"
' > /etc/locale.conf


# 设置时区
timedatectl set-timezone Asia/Chongqing
# or
# cp /usr/share/zoneinfo/Asia/Chongqing /etc/localtime


# 安装 epel 仓库
dnf config-manager --set-enabled crb
dnf install -y \
    https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm \
    https://dl.fedoraproject.org/pub/epel/epel-next-release-latest-9.noarch.rpm

yum-config-manager --enable epel


dnf install -y curl wget yum-utils

# 设置 `rc.local` 自动执行
chmod +x /etc/rc.d/rc.local


# 安装核心工具
dnf install -y bash-completion \
  bzip2 \
  iotop iptraf-ng \
  jq \
  libuv lsof \
  mtr net-tools \
  traceroute \
  uuid \
  zstd

# 安装常用工具
dnf install -y bind-utils \
  dnsmasq \
  dstat \
  elfutils-libelf-devel \
  lm_sensors \
  mlocate \
  nfs-utils nmap \
  pcp \
  rpcbind \
  readline-devel \
  ripgrep \
  rsync \
  sysstat \
  telnet \
  usbutils \
  vim \
  vsftpd \
  whois


# 安装基本编译环境
dnf groupinstall "Development Tools"



# 升级 重启
dnf update -y
dnf makecache
reboot
