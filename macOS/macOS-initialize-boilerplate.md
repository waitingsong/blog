# <center> macOS 初始化配置 </center>


## 准备

- **以 `root` 用户登录系统执行以下所有操作**
  ```sh
  sudo su -
  ```
- 确认可以访问因特网



## 新增系统默认用户


生成账号 ssh 密钥对
```sh
```


## 更新配置



## 更新证书

```sh

```


## 安装应用

```sh

```


## 安装开发环境



## 设置定时任务

```sh
sudo crontab -e
```

```
30 23 * * * rm -rf /Users/sqy/Library/Developer/Xcode/DerivedData
0 9,12,18 * * * cp -f /etc/ssh/sshd_config.ok /etc/ssh/sshd_config

30 0 * * * /usr/local/bin/brew update
0 18 * * * /usr/local/bin/brew upgrade
```


## 设置服务器接受 ssh 公钥登录

先重启服务器
```sh
reboot
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

设置服务器**仅**接受ssh公钥登录（可选）  
**确认以上操作成功并且成功使用公钥登录系统后继续下面操作**
```sh
cp /etc/ssh/sshd_config /etc/ssh/ori_sshd_config
sed -i "s/^\s*\(PasswordAuthentication.*\)/# \1/" /etc/ssh/sshd_config
echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config
```


## 资源
- [Mozilla CA证书](https://curl.haxx.se/docs/caextract.html) 
- [Kubectl 效率提升指北](https://www.kubernetes.org.cn/5269.html)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)




https://stackoverflow.com/questions/39622173/cant-run-ssh-x-on-macos-sierra


git config --global http.proxy http://127.0.0.1:7890

