# <center> 腾讯云 CVM CentOS8 自定义镜像初始化配置 </center>

## 目的
基于腾讯云 CVM 基础 CentOS7 64bit 镜像初始化配置制作自定义镜像用于安装 Kerbernetes 集群节点


## 准备

- **以 `root` 用户登录系统执行以下所有操作**
- 确认可以访问因特网
- 建议以 `ssh` 客户端连接服务器进行操作， 比如 `xshell`, `putty`


## 确认关闭 SELinux

```sh
dnf upgrade --refresh -y
dnf update -y
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
sh ./Linux/script/00.init.sh
sh ./Linux/script/01.user.sh
```


## 查看当前时区
```sh
timedatectl
# 查看可用时区
timedatectl list-timezones
```


## 升级系统
```sh
# wget -O /etc/yum.repos.d/CentOS-ali.repo https://mirrors.aliyun.com/repo/Centos-8.repo
# # 非阿里云 ECS 用户执行
# sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-ali.repo

# cd /etc/yum.repos.d
# rm -f CentOS-Linux-*
# mv -f CentOS-Base.repo{,.bak}
# mv -f CentOS-AppStream.repo{,.bak}
# mv -f CentOS-Extras.repo{,.bak}
# mv -f CentOS-PowerTools.repo{,.bak}
# mv -f CentOS-centosplus.repo{,.bak}
```


## 增强系统安全

授权用户 `sudo visudo` 末尾添加以下内容
```
Defaults: ALL timestamp_timeout=15
admin  ALL=(ALL)       ALL
admins  ALL=(ALL)       ALL
admin2 ALL=(root)     NOPASSWD: ALL
```

修改 ssh 登录设置
```sh
sh ./Linux/script/02.ssh-config.sh
```


## 更新系统 CA 证书集

```sh
sh ./Linux/script/03.update-crt-ios.sh
```

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
  screen.x86_64 \
  zlib-devel \
```



## 系统性能调整

```sh
sh ./Linux/script/04.tune.sh
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

```sh
sh ./Linux/script/05.set-config.global.sh
sh ./Linux/script/06.set-config.local.sh
```


## 开启相关服务

```sh
sh ./Linux/script/07.service.sh
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




定时任务
- 执行
  ```sh
  crontab -e
  ```
- 新增记录
  ```
  0 6 * * * /usr/bin/updatedb
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
sh ./Linux/script/21.ssh-only-crt.sh
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

