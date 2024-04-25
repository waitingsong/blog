#!/bin/sh
set -e


echo ==================== 安装语言包 ====================
dnf install -y wget curl langpacks-zh_CN langpacks-en langpacks-en_GB pwgen


echo ==================== 卸载相关软件 ====================
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


echo ==================== 设置时区 ====================
timedatectl set-timezone Asia/Chongqing
# or
# cp /usr/share/zoneinfo/Asia/Chongqing /etc/localtime


echo ==================== 安装 epel 仓库 ====================
dnf install 'dnf-command(config-manager)'
dnf config-manager --set-enabled crb
dnf install -y \
  https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm \
  https://dl.fedoraproject.org/pub/epel/epel-next-release-latest-9.noarch.rpm

dnf config-manager --enable epel
dnf install -y curl wget yum-utils

echo ==================== 设置 `rc.local` 自动执行 ====================
chmod +x /etc/rc.d/rc.local


echo ========== 安装核心工具 ==========
dnf install -y bash-completion \
  bzip2 \
  iotop iptraf-ng \
  jq \
  libuv lsof \
  mtr net-tools \
  traceroute \
  uuid \
  zstd

echo ==================== 安装常用工具 ====================
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


echo ==================== 安装基本编译环境 ====================
dnf groupinstall -y "Development Tools"


echo ==================== 升级 ====================
dnf update -y
dnf makecache

echo     ==================== 重启 ====================
reboot

