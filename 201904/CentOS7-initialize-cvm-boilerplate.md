### <center> 腾讯云 CVM CentOS7 自定义镜像初始化配置 </center>

#### 目的
基于腾讯云 CVM 基础 CentOS7 64bit 镜像初始化配置制作自定义镜像用于安装 Kerbernetes 集群节点


#### 准备

- **以 `root` 用户登录系统执行以下所有操作**
- 确认可以访问因特网


#### 配置界面语言

查看配置信息，执行命令
```bash
locale
```

执行 
```bash
echo '
LANG="en_US.UTF-8"
LC_TIME="en_US.UTF-8"
LC_MESSAGES="en_US.UTF-8"
SUPPORTED="zh_CN.UTF-8:zh_CN.GB18030:zh_CN:zh:en_US.UTF-8:en_US:en"
SYSFONT="latarcyrheb-sun16"
' > /etc/locale.conf
```

#### 设置时区

```bash
cp /usr/share/zoneinfo/Asia/Chongqing /etc/localtime
```

#### 删除防火墙及 ntp
```bash
yum remove -y firewalld python-firewall firewalld-filesystem ntp
```

#### 升级系统
```bash
yum update -y
reboot
```

#### 安装 `yum` 加速及核心包
```bash
yum install -y deltarpm wget curl yum-priorities yum-axelget \
  yum-utils device-mapper-persistent-data lvm2 \
  tzdata python \
```


#### 确认关闭 SELinux
- 检测selinux状态，执行 `getenforce`，应该显示 `>> disabled` 否则执行以下操作
- 执行 `vi /etc/selinux/config`
- 设置 `SELINUX=disabled`
- 重启系统


#### 设置 `rc.local` 自动执行
 ```bash
 chmod +x /etc/rc.d/rc.local
 ```

#### 新增系统默认用户

新增常用用户、新建目录
```bash
useradd -u2000 admin
```

设置 admin 用户口令 
```bash
passwd admin
```

```bash
useradd -u2001 -M -s /bin/false www
useradd -u2002 -G www -M -s /bin/false nginx
useradd -u2003 git
usermod -aG www admin
groupadd -g26 postgres
useradd -u26 -g26 postgres
useradd -u2007 -M -s /bin/false docker
useradd -u2008 -M -s /bin/false pgbouncer
usermod -aG docker admin
```

生成 `root` 和 `admin` 账号的 ssh 密钥对
```bash
ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519
sudo -u admin sh -c "ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519"
```


#### 增强系统安全

授权用户 `admin` 用于sudo执行权限 执行 `visudo` 末尾添加以下内容
```
Defaults: admin        timestamp_timeout=15
admin  ALL=(ALL)       ALL
```

修改 ssh 登录设置
```bash
sed -i "s/^\s*\(AllowUsers.*\)/# \1/" /etc/ssh/sshd_config
sed -i "s/^\s*\(PubkeyAuthentication .*\)/# \1/" /etc/ssh/sshd_config
echo 'PubkeyAuthentication yes' >> /etc/ssh/sshd_config
echo 'AllowUsers git admin root' >> /etc/ssh/sshd_config
echo '' >> /etc/ssh/sshd_config
```

设置仅允许 Ed25519 算法证书
```bash
sed -i "s/\(^\s*HostKey.\+ssh_host_rsa_key\)/# \1/" /etc/ssh/sshd_config
sed -i "s/\(^\s*HostKey.\+ssh_host_dsa_key\)/# \1/" /etc/ssh/sshd_config
sed -i "s/\(^\s*HostKey.\+ssh_host_ecdsa_key\)/# \1/" /etc/ssh/sshd_config
sed -i "s/^#\s*\(HostKey.\+ssh_host_ed25519_key\)/\1/" /etc/ssh/sshd_config
```

#### 更新系统 CA 证书集

```bash
#cp /tmp/ca-ec.crt /etc/pki/ca-trust/source/anchors/
wget -O /etc/pki/ca-trust/source/anchors/ca-bundle.pem https://curl.haxx.se/ca/cacert.pem
update-ca-trust
```


#### 安装常用工具

```bash
yum install -y bash-completion bind-utils \
  curl chrony \
  dstat \
  expect finger gd git gpm \
  htop iotop iptstate iptraf-ng iperf \
  jwhois \
  libuv lsof lynx \
  mtr net-tools nfs-utils nmap \
  p7zip \
  rsync \
  sysstat screen telnet traceroute \
  uuid unzip vim \
```


#### 安装编译环境
```bash
yum install -y make \
  autoconf automake \
  cmake \
  gcc gcc-c++ \
  glibc glibc-devel glib2 glib2-devel \
  gmp gmp-devel \
  libevent libevent-devel \
  libtool \
  zlib zlib-devel \
```


#### 安装集群相关软件
```bash
yum install -y conntrack-tools \
  ipset ipvsadm \
  keepalived jq \
  psmisc socat \
```

安装 jid 
```bash
cd /tmp
wget https://github.com/simeji/jid/releases/download/v0.7.6/jid_linux_amd64.zip
unzip jid_linux_amd64.zip -d /usr/local/bin/
```

命令缩写
```bash
cat>>/usr/local/bin/kubectl-ls<<EOF
#!/bin/bash

# see if we have custom-columns-file defined
if [ ! -z "$1" ] && [ -f $HOME/.kube/columns/$1 ];
then
  kubectl get -o=custom-columns-file=$HOME/.kube/columns/$1 $@
else
  kubectl get $@
fi
EOF

chmod a+x /usr/local/bin/kubectl-ls
# 查看效果
k ls deploy
```

显示 CRD 扩展信息
```bash
mkdir -p ~/.kube/columns
cat>>~/.kube/columns/prometheus<<EOF
NAME          REPLICAS      VERSION      CPU                         MEMORY                         ALERTMANAGER
metadata.name spec.replicas spec.version spec.resources.requests.cpu spec.resources.requests.memory spec.alerting.alertmanagers[*].name
EOF

# 查看效果
k ls prometheus k8s
```


#### 编译安装 `opessl` 版本

Centos7 自带版本为 1.0.2，更新为最新版

下载源代码编辑安装
```bash
cd /usr/local/src
git clone -b master --depth=1 https://github.com/openssl/openssl
cd openssl
make clean

./config --prefix=/usr/local/ssl \
  --openssldir=/usr/local/ssl \
  shared zlib-dynamic \
  enable-ec_nistp_64_gcc_128 \
  no-ssl3 \

make depend && make all && make install
```

配置动态链接库路径
```bash
echo "/usr/local/ssl/lib" >> /etc/ld.so.conf
ldconfig /usr/local/ssl/lib
ldd /usr/local/ssl/bin/openssl 
ldconfig -v
```

更新全局搜索路径
```bash
echo 'PATH=/usr/local/ssl/bin:$PATH' >> /etc/bashrc
```

更新配置（或者重新登录用户）
```bash
. /etc/bashrc
openssl version
  
# OpenSSL 3.0.0-dev xx XXX xxxx
```


#### 开启相关服务

- 计划任务
  ```bash
  systemctl enable crond
  systemctl start crond
  ```


#### 系统性能调整

- 内核 TCP/IP、Socket参数调优
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

- 内存 4GB 及以上的可开启巨页面支持  
  设置 256 实际占用内存为 256*2MB=512MB，随内存增加. 8GB 内存可设定为 512 占用 1GB
  ```bash
  touch /etc/sysctl.d/99-sysctl.conf
  echo 'vm.nr_hugepages=256' >> /etc/sysctl.conf
  sysctl -p
  ```

- 查看巨页面设置 `cat /proc/meminfo | grep Huge`
  **注意** `Oracle 11g` 默认启用的AMM功能不支持巨页面, 但ASMM支持  
  临时更改大页面值可使用命令 `sysctl vm.nr_hugepages=512`


- （可选）16GB 内存以上可把 `/tmp` 挂接到内存中
  ```bash
  systemctl enable tmp.mount
  systemctl start tmp.mount
  ```


#### 常用配置设置

VIM 设置 避免vim粘贴时自动格式化缩进，（粘贴开始前后用F9手工切换）执行
```bash
echo 'set pastetoggle=<F9>' >> /root/.vimrc
echo 'set pastetoggle=<F9>' >> /home/admin/.vimrc
```

增加命令别名
```bash
cat>>/etc/bashrc<<EOF

alias crontab='crontab -i'
alias dk='docker'
alias dkps='docker ps --format "table {{.Image}}\t{{.Command}}\t{{.RunningFor}}\t{{.Status}}\t{{.Names}}\t{{.Mounts}}"'
alias sudo='sudo '
alias vi='vim'
alias rm='rm -i'
alias dstat='dstat -cdlmnpsy'
alias allnst="netstat -n |awk '/^tcp/ {++S[\$NF]} END {for(a in S) print a, S[a]}'"
alias usenst="netstat -an | grep 80 | awk '{print \$6}' | sort | uniq -c | sort -rn"
alias webnst="netstat -nat|grep ":80"|awk '{print \$5}' |awk -F: '{print \$1}' | sort| uniq -c|sort -rn|head -n 10"
alias k='kubectl'
alias ka='kubectl apply --recursive -f'
alias kex='kubectl exec -it'
alias klo='kubectl logs -f'
alias kg='kubectl get'
alias kd='kubectl describe'
# vim:ts=4:sw=4

EOF

```

登录显示信息
```bash
echo 'df -lhT' >> /etc/profile
```


#### 设置服务器仅接受 ssh 公钥登录
```bash
reboot
```

添加 deploy 节点公钥
```bash
echo 'deploy节点公钥文件内容' >> /root/.ssh/authorized_keys
echo 'deploy节点公钥文件内容' >> /home/admin/.ssh/authorized_keys
```

设置服务器**仅**接受ssh公钥登录（禁止通过口令登录系统）
```bash
sed -i "s/^\s*\(PasswordAuthentication.*\)/# \1/" /etc/ssh/sshd_config
echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config
echo '' >> /etc/ssh/sshd_config
```

重启服务器
```bash
reboot
```


#### 升级内核到 v5
见文档 [升级 kernel](./CentOS7-update-kernel.md)

#### 开启 TCP BBR 算法
执行
```sh
cd /usr/local/src
wget https://github.com/teddysun/across/raw/master/bbr.sh 
sh bbr.sh
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

#### 完成设置后重启系统
```bash
reboot
```

#### 以此系统制作 k8s-node 镜像，用于自定义镜像安装以后的 k8s 节点


#### 资源
- [Mozilla CA证书](https://curl.haxx.se/docs/caextract.html) 
- [Kubectl 效率提升指北](https://www.kubernetes.org.cn/5269.html)
