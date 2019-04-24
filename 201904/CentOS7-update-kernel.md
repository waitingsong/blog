### <center> CENTOS7 升级最新 Linux 内核 </center>


#### 准备

- **以 `root` 用户登录系统执行以下所有操作**
- 确认可以访问因特网

#### 安装 ELRepo 库
```bash
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
yum install -y https://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
```

#### 可选核心列表
```bash
yum --disablerepo="*" --enablerepo="elrepo-kernel" list available
```

#### 安装最新主线稳定版
```bash
yum --enablerepo=elrepo-kernel install -y kernel-ml
```

#### 查看当前已安装核心版本
```bash
awk -F\' '$1=="menuentry " {print i++ " : " $2}' /etc/grub2.cfg
```

#### 设置首位 0 作为默认启动核心
```bash
grub2-set-default 0
grub2-mkconfig -o /boot/grub2/grub.cfg
reboot
```

#### 注意事项
执行 `yum update` 可能将更新到官方新的低版本内核，此后需要手工重新指定启动内核。
或者升级排除内核
```bash
yum update --exclude=kernel*
```


#### （可选）清除旧内核文件 保留最近两个
```bash
yum install -y yum-utils
package-cleanup --oldkernels
```
