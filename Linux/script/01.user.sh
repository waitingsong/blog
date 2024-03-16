#!/bin/sh
set -e


# 新增系统默认用户
useradd -u2000 admins
pwgen -s 32 1 | passwd admins --stdin

useradd -u2001 -M -s /bin/false www
usermod -aG www admins

useradd -u2002 -G www -M -s /bin/false nginx

useradd -u2003 git

groupadd -g26 postgres
useradd -u26 -g26 postgres
useradd -u2005 -M -s /bin/false smbuser
useradd -u2006 -M -s /bin/false smbadmins
useradd -u2007 -M -s /bin/false docker
useradd -u2008 -M -s /bin/false pgbouncer

useradd -u2009 ci
pwgen -s 32 1 | passwd ci --stdin
usermod -aG docker ci

usermod -aG docker admins
useradd -u2100 -M -s /bin/false node

useradd -u2010 admin
pwgen -s 32 1 | passwd admin --stdin
usermod -aG admin admins

useradd -u2011 admin2
pwgen -s 32 1 | passwd admin2 --stdin
usermod -aG admin2 admins

sudo -u root sh -c "ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519"
sudo -u admin sh -c "ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519"
sudo -u admin2 sh -c "ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519"
sudo -u admins sh -c "ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519"