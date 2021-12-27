# <center> 腾讯云 CVM CentOS8 自定义镜像初始化配置 </center>

## 目的
基于腾讯云 CVM 基础 CentOS7 64bit 镜像初始化配置制作自定义镜像用于安装 Kerbernetes 集群节点


## 准备

- **以 `root` 用户登录系统执行以下所有操作**
- 确认可以访问因特网
- 建议以 `ssh` 客户端连接服务器进行操作， 比如 `xshell`, `putty`


## 确认关闭 SELinux

```sh
sed -i 's|SELINUX=\w*|SELINUX=disabled|' /etc/selinux/config
reboot
# 重启之后执行, 应该显示 Disabled 
getenforce
```


## 配置界面语言

查看配置信息，执行命令
```sh
locale
```

执行 
```sh
dnf install -y wget curl langpacks-zh_CN langpacks-en langpacks-en_GB

echo '
LANG="en_US.UTF-8"
LC_TIME="en_US.UTF-8"
LC_MESSAGES="en_US.UTF-8"
SUPPORTED="zh_CN.UTF-8:zh_CN.GB18030:zh_CN:zh:en_US.UTF-8:en_US:en"
SYSFONT="latarcyrheb-sun16"
' > /etc/locale.conf
```

## 设置时区

```sh
timedatectl set-timezone Asia/Chongqing
# or
cp /usr/share/zoneinfo/Asia/Chongqing /etc/localtime

# 查看当前时区
timedatectl
# 查看可用时区
timedatectl list-timezones
```

## 删除程序
```sh
dnf remove -y firewalld python-firewall firewalld-filesystem ntp \
  selinux-policy \
  docker \
  docker-client \
  docker-client-latest \
  docker-common \
  docker-latest \
  docker-latest-logrotate \
  docker-logrotate \
  docker-engine \
```


## 升级系统
```sh
wget -O /etc/yum.repos.d/CentOS-ali.repo https://mirrors.aliyun.com/repo/Centos-8.repo
# 非阿里云 ECS 用户执行
sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-ali.repo

cd /etc/yum.repos.d
rm -f CentOS-Linux-*
mv -f CentOS-Base.repo{,.bak}
mv -f CentOS-AppStream.repo{,.bak}
mv -f CentOS-Extras.repo{,.bak}
mv -f CentOS-PowerTools.repo{,.bak}
mv -f CentOS-centosplus.repo{,.bak}
```


## 安装 epel 仓库
```sh
dnf install -y https://mirrors.aliyun.com/epel/epel-release-latest-8.noarch.rpm
```
将 repo 配置中的地址替换为阿里云镜像站地址
```sh
sed -i 's|^#baseurl=https://download.fedoraproject.org/pub|baseurl=https://mirrors.aliyun.com|' /etc/yum.repos.d/epel*
sed -i 's|^metalink|#metalink|' /etc/yum.repos.d/epel*
dnf makecache
dnf repolist -v
```


```sh
dnf install -y curl wget yum-utils 
dnf update -y
# update 之后需要重新执行
cd /etc/yum.repos.d
rm -f CentOS-Linux-*
mv -f CentOS-Base.repo{,.bak}
mv -f CentOS-AppStream.repo{,.bak}
mv -f CentOS-Extras.repo{,.bak}
mv -f CentOS-PowerTools.repo{,.bak}
mv -f CentOS-centosplus.repo{,.bak}
dnf makecache
reboot
```


## 设置 `rc.local` 自动执行

```sh
chmod +x /etc/rc.d/rc.local
```

## 新增系统默认用户

新增常用用户、新建目录
```sh
useradd -u2000 admin
passwd admin
```

新增其它用户
```sh
useradd -u2001 -M -s /bin/false www
useradd -u2002 -G www -M -s /bin/false nginx
useradd -u2003 git
usermod -aG www admin
groupadd -g26 postgres
useradd -u26 -g26 postgres
useradd -u2005 -M -s /bin/false smbuser
useradd -u2006 -M -s /bin/false smbadmin
useradd -u2007 -M -s /bin/false docker
useradd -u2008 -M -s /bin/false pgbouncer
useradd -u2009 ci
usermod -aG docker ci
usermod -aG docker admin
useradd -u2100 -M -s /bin/false node
```

生成账号 ssh 密钥对
```sh
ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519
sudo -u admin sh -c "ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519"
sudo -u ci sh -c "ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519"
sudo -u git sh -c "ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519"
```


## 增强系统安全

授权用户 `sudo` 执行权限 执行 `visudo` 末尾添加以下内容
```
Defaults: admin        timestamp_timeout=15
admin  ALL=(ALL)       ALL
```

修改 ssh 登录设置
```sh
sed -i "s/^\s*\(AllowUsers.*\)/# \1/" /etc/ssh/sshd_config
sed -i "s/^\s*\(PubkeyAuthentication .*\)/# \1/" /etc/ssh/sshd_config
echo 'PubkeyAuthentication yes' >> /etc/ssh/sshd_config
echo 'AllowUsers git admin root ci' >> /etc/ssh/sshd_config
echo '' >> /etc/ssh/sshd_config
```

设置仅允许 Ed25519 算法证书
```sh
sed -i "s/\(^\s*HostKey.\+ssh_host_rsa_key\)/# \1/" /etc/ssh/sshd_config
sed -i "s/\(^\s*HostKey.\+ssh_host_dsa_key\)/# \1/" /etc/ssh/sshd_config
sed -i "s/\(^\s*HostKey.\+ssh_host_ecdsa_key\)/# \1/" /etc/ssh/sshd_config
sed -i "s/^#\s*\(HostKey.\+ssh_host_ed25519_key\)/\1/" /etc/ssh/sshd_config
```


## 更新系统 CA 证书集

准备自签发CA证书
```sh
echo '-----BEGIN CERTIFICATE-----
MIIC0z
...
B0PWZ8jBcg==
-----END CERTIFICATE-----' > ca-ec.crt
```

执行
```sh
cp ca-ec.crt /etc/pki/ca-trust/source/anchors/
wget -O /etc/pki/ca-trust/source/anchors/ca-bundle.pem https://curl.haxx.se/ca/cacert.pem
update-ca-trust
```
[文档](https://curl.haxx.se/docs/caextract.html) 


## 安装核心工具

```sh
dnf install -y bash-completion \
  bzip2 \
  htop iotop iptraf-ng \
  jq \
  libuv lsof \
  mtr net-tools \
  screen \
  traceroute \
  uuid \
  zstd \
```


## 安装常用工具

```sh
dnf install -y bind-utils \
  dnsmasq \
  dstat \
  elfutils-libelf-devel \
  lm_sensors \
  mlocate \
  nfs-utils nmap \
  p7zip \
  pcp \
  rpcbind \
  readline-devel \
  rsync \
  sysstat \
  telnet \
  usbutils \
  vim \
  vsftpd \
  whois \
```


## 安装基本编译环境

```sh
dnf install -y automake cmake make \
  gcc gcc-c++ \
  glibc-devel glib2-devel \
  gpm \
```


## （可选）安装扩展编译环境

```sh
dnf install -y \
  bison bzip2-devel \
  curl-devel \
  flex fontconfig-devel freetype freetype-devel \
  GeoIP GeoIP-devel \
  glibc-devel glib2-devel \
  gmp gmp-devel \
  libevent-devel \
  libicu libicu-devel \
  libtool \
  ncurses-devel \
  pam-devel pcre-devel \
  perl perl-devel perl-ExtUtils-Embed  \
  zlib-devel \
```



## 开启相关服务

计划任务
```sh
systemctl enable --now crond
```

精确时钟同步服务（云服务器可跳过）
- 更新时钟源 
  ```
  vi /etc/chrony.conf
  ``` 
  ```
  #pool 2.centos.pool.ntp.org iburst
  server 0.cn.pool.ntp.org
  server 1.cn.pool.ntp.org
  server ntp1.aliyun.com
  server ntp2.aliyun.com
  server time1.cloud.tencent.com
  server time2.cloud.tencent.com
  ```
- 开启服务
  ```sh
  systemctl enable --now chronyd.service
  ```
- 检查运行状况
  ```sh
  chronyc sourcestats
  chronyc sources
  chronyc tracking
  timedatectl
  ```
- 对于无法访问外网情况 编辑 `/etc/chrony.conf` 文件指定内网 `ntp` 服务器地址


## 系统性能调整

内核 TCP/IP、Socket参数调优
```sh
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

sysctl -p
```

对于大内存服务器可以编辑以下文件设置小交换频率，
```sh
cat /proc/sys/vm/swappiness
touch /etc/sysctl.d/99-sysctl.conf
echo vm.swappiness=5 >> /etc/sysctl.d/99-sysctl.conf
sysctl -p
```

（可选）16GB 内存以上可把 `/tmp` 挂接到内存中
```sh
systemctl enable tmp.mount
systemctl start tmp.mount
```


## 常用配置设置

VIM 设置 避免vim粘贴时自动格式化缩进，（粘贴开始前后用F9手工切换）执行
```sh
cat>> /root/.vimrc <<EOF
set sw=2
set ts=2
filetype indent on
set pastetoggle=<F9>
EOF


cat>> /home/admin/.vimrc <<EOF
set sw=2
set ts=2
filetype indent on
set pastetoggle=<F9>
EOF

```

增加命令别名
```sh
cat>> /etc/bashrc <<EOF
alias crontab='crontab -i'
alias lla='ls -al --color=auto'
alias llh='ls -alh --color=auto'
alias tarz='tar -I zstdmt'
alias dc='docker-compose'
alias dk='docker'
alias dkc='docker container'
alias dki='docker image'
alias dkv='docker volume'
alias dkis='docker inspect'
alias dkps='docker ps --format "table {{.Image}}\t{{.Command}}\t{{.RunningFor}}\t{{.Status}}\t{{.Names}}\t{{.Mounts}}"'
alias dkst='docker stats'

alias dkiif='docker image inspect -f "Id:{{.Id}} {{println}}\
Created: {{.Created}} {{println}}\
RepoDigests: {{range .RepoDigests}}{{println}}  {{.}}{{end}} {{println}}\
RepoTags: {{range .RepoTags}}{{println}}  {{.}}{{end}} {{println}}\
Layers: {{range .RootFS.Layers}}{{println}}  {{.}}{{end}} {{println}}\
Labels: {{json .Config.Labels}}\
"'

alias sudo='sudo '
alias vi='vim'
alias rm='rm -i'
alias dstat='dstat -cdlmnpsy'
alias ntt='netstat -tunpl'
alias allnst="netstat -n |awk '/^tcp/ {++S[\$NF]} END {for(a in S) print a, S[a]}'"
alias usenst="netstat -an | grep 80 | awk '{print \$6}' | sort | uniq -c | sort -rn"
alias webnst="netstat -nat|grep ":80"|awk '{print \$5}' |awk -F: '{print \$1}' | sort| uniq -c|sort -rn|head -n 10"
alias k='kubectl'
alias ka='kubectl apply --recursive -f'
alias kex='kubectl exec -it'
alias klo='kubectl logs -f'
alias kg='kubectl get'
alias kd='kubectl describe'
EOF

```

登录显示信息及配置
```sh
cat>> /etc/profile <<EOF
export XZ_DEFAULTS='-T 0'
export ZSTD_CLEVEL=9
df -lhT
EOF

```

增加最大打开文件句柄数量
```sh
echo 'ulimit -SHn 65535' >> /etc/rc.local
```

定时任务
- 执行
  ```sh
  crontab -e
  ```
- 新增记录
  ```
  0 6 * * * /usr/bin/updatedb
  ```

安装中文字体
```sh
dnf install -y wqy-unibit-fonts.noarch wqy-microhei-fonts.noarch
```


## 开启 TCP BBR 算法
```sh
echo net.core.default_qdisc=fq >> /etc/sysctl.conf
echo net.ipv4.tcp_congestion_control=bbr >> /etc/sysctl.conf
sysctl -p
```

检查
```sh
sysctl net.ipv4.tcp_available_congestion_control
# 返回值应为：
net.ipv4.tcp_available_congestion_control = cubic reno bbr 

sysctl net.core.default_qdisc
# 返回值应为：
net.core.default_qdisc = fq

lsmod | grep bbr
# 返回值有 tcp_bbr 模块即说明bbr已启动
```


## 设置服务器接受 ssh 公钥登录

先重启服务器
```sh
reboot
```

添加 deploy 节点公钥
```sh
echo 'deploy节点公钥文件内容' >> /root/.ssh/authorized_keys
echo 'deploy节点公钥文件内容' >> /home/admin/.ssh/authorized_keys

# eg.
echo 'ssh-ed25519 AAAAC...GMq ed25519 256-111017' >> /root/.ssh/authorized_keys
```

客户端上传公钥到服务器
- 生成 ssh 公钥对    
  在**客户端电脑** 使用 `git-bash` 执行命令，以自己邮箱地址替换
  ```sh
  ssh-keygen -t ed25519 -C <邮箱地址|识别名>
  ```
  生成的公钥私钥文件保存在你的`用户空间/.ssh/`目录下面，windows 系统通常为
  `C:\users\<系统登录用户名>\.ssh\`
- 绑定公钥到登录用户
  ```sh
  ssh-copy-id -i ~/.ssh/id_ed25519.pub  root@<ip|服务器名|域名>
  ```
- 若服务器 `ssh` 非标准端口 （假定 1022 端口）
  ```sh
  ssh-copy-id -i ~/.ssh/id_rsa.pub "-p 1022 root@<ip|服务器名|域名>" 
  ```

设置服务器**仅**接受ssh公钥登录（可选）  
**确认以上操作成功并且成功使用公钥登录系统后继续下面操作**
```sh
cp /etc/ssh/sshd_config /etc/ssh/ori_sshd_config
sed -i "s/^\s*\(PasswordAuthentication.*\)/# \1/" /etc/ssh/sshd_config
echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config
```


## 安装 kubectl

```sh
curl -LO https://dl.k8s.io/release/v1.21.0/bin/linux/amd64/kubectl
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(<kubectl.sha256) kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```


## 安装 k8s 集群相关软件
```sh
yum install -y conntrack-tools \
  ipset ipvsadm \
  keepalived jq \
  psmisc socat \
```

安装 jid 
```sh
cd /tmp
wget https://github.com/simeji/jid/releases/download/v0.7.6/jid_linux_amd64.zip
unzip jid_linux_amd64.zip -d /usr/local/bin/
rm jid_linux_amd64.zip -f
```

命令缩写
```sh
cat>>/usr/local/bin/kubectl-ls<<EOF
#!/bin/bash

# see if we have custom-columns-file defined
if [ ! -z "\$1" ] && [ -f \$HOME/.kube/columns/\$1 ];
then
  kubectl get -o=custom-columns-file=\$HOME/.kube/columns/\$1 \$@
else
  kubectl get \$@
fi
EOF

chmod a+x /usr/local/bin/kubectl-ls
# 查看效果
k ls deploy
```

显示 CRD 扩展信息
```sh
mkdir -p ~/.kube/columns
cat>>~/.kube/columns/prometheus<<EOF
NAME          REPLICAS      VERSION      CPU                         MEMORY                         ALERTMANAGER
metadata.name spec.replicas spec.version spec.resources.requests.cpu spec.resources.requests.memory spec.alerting.alertmanagers[*].name
EOF

# 查看效果
k ls prometheus k8s
```

## 完成设置后重启系统
```sh
reboot
```

查看系统温度
```sh
sensors
```

## 以此系统制作 k8s-node 镜像，用于自定义镜像安装以后的 k8s 节点


## 测试
1. 网络带宽
- 本机运行
  ```sh
  iperf3 -s
  ```
- 其它机器执行
  ```sh
  iperf -c 本机ip地址 -p 5201
  ```
- 本机回环
  ```sh
  iperf -c 127.0.0.1 -p 5201
  ```

## 资源
- [Mozilla CA证书](https://curl.haxx.se/docs/caextract.html) 
- [Kubectl 效率提升指北](https://www.kubernetes.org.cn/5269.html)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)

