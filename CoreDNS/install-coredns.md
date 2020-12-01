# <center>CoreDNS 安装</center>


以 `root` 用户登录执行以下操作

准备镜像
```sh
docker pull coredns/coredns
```

若 53 端口可能被系统 `systemd-resolved` 占用
```sh
sudo lsof -i :53
systemctl disable --now systemd-resolved
```

拷贝目录 [./asset](./asset) 到服务器

备份文件
```sh
mv /etc/resolv.conf /etc/resolv-coredns.conf
cat> /etc/resolv.conf <<EOF
# redirect to local coredns
# original is resolv-coredns.conf
# note: use external ip for running docker instead of 127.0.0.1 !
nameserver 127.0.0.1
EOF

# https://askubuntu.com/questions/623940/network-manager-how-to-stop-nm-updating-etc-resolv-conf
sed -i 's|\(dns=w*\)|#\1|' /etc/NetworkManager/NetworkManager.conf
sed -i 's|\[main\]|[main]\ndns=none\n|' /etc/NetworkManager/NetworkManager.conf
```

以 `docker-compose` 启动服务
```sh
cd ./asset
docker-compose up -d
```

查看日志
```sh
docker logs -f coredns
```

测试
```sh
curl -si 127.0.0.1:10053/ready
curl -si 127.0.0.1:10054/health
```
输出
```
HTTP/1.1 200 OK
Date: Tue, 01 Dec 2020 05:31:35 GMT
Content-Length: 2
Content-Type: text/plain; charset=utf-8
```

```sh
dig @localhost  CH version.bind TXT
dig @localhost -p 53 whoami
```

添加静态解析
```sh
echo '192.168.1.2 gitlab' >> /etc/hosts
```

