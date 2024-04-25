#!/bin/sh
set -e


echo ========== ==========
echo ==================== 新增系统默认用户 ====================

useradd -u2000 admins
pwgen -s 64 1 | passwd admins --stdin

useradd -u2001 -M -s /bin/false www
useradd -u2002 -G www -M -s /bin/false nginx
useradd -u2003 git
pwgen -s 64 1 | passwd git --stdin

groupadd -g26 postgres
useradd -u26 -g26 postgres
pwgen -s 64 1 | passwd postgres --stdin

useradd -u2005 -M -s /bin/false smbuser
useradd -u2006 -M -s /bin/false smbadmins
useradd -u2007 -M -s /bin/false docker
useradd -u2008 -M -s /bin/false pgbouncer

useradd -u2009 ci
pwgen -s 64 1 | passwd ci --stdin

useradd -u2100 -M -s /bin/false node

useradd -u2010 admin
pwgen -s 64 1 | passwd admin --stdin

usermod -aG docker,www ci
usermod -aG admins,docker admin
usermod -aG docker,www,admin,ci admins

echo ==================== 生成用户密钥 ====================

sudo -u root sh -c "ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519"
sudo -u admin sh -c "ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519"
sudo -u admins sh -c "ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519"
sudo -u git sh -c "ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519"
sudo -u ci sh -c "ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519"
sudo -u postgres sh -c "ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519"