# CentOS 7/8 安装 Docker-CE


## 安装依赖
```sh
dnf install -y device-mapper-persistent-data lvm2

# dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
dnf config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
# dnf config-manager --add-repo https://mirrors.cloud.tencent.com/docker-ce/linux/centos/docker-ce.repo


mkdir -p /data/.docker /data/docker /etc/docker
chown root:root /data/.docker
chown docker:docker /data/docker
chmod 775 /data/docker
```

## 安装

- 最新版
  ```sh
  dnf install docker-ce docker-ce-cli containerd.io docker-compose-plugin
  ```
- 定版本
  - Step 1: 查找Docker-CE的版本:
    ```sh
    dnf list docker-ce --showduplicates | sort -r
    ```
  - Step2 : 安装指定版本的Docker-CE: (VERSION 例如上面的 17.03.0.ce.1-1.el7.centos)
    ```sh
    dnf -y install docker-ce-[VERSION] docker-ce-cli-[VERSION]
    ```

- 安装校验
  ```sh
  systemctl enable --now docker
  # 应该输出 active
  systemctl is-active docker
  docker version
  ```
  输出
  ```
  Client: Docker Engine - Community
  Version:           25.0.3
  API version:       1.44
  Go version:        go1.21.6
  Git commit:        4debf41
  Built:             Tue Feb  6 21:14:42 2024
  OS/Arch:           linux/amd64
  Context:           default

  Server: Docker Engine - Community
  Engine:
    Version:          25.0.3
    API version:      1.44 (minimum version 1.24)
    Go version:       go1.21.6
    Git commit:       f417435
    Built:            Tue Feb  6 21:13:06 2024
    OS/Arch:          linux/amd64
    Experimental:     false
  containerd:
    Version:          1.6.28
    GitCommit:        ae07eda36dd25f8a1b98dfbf587313b99c0190bb
  runc:
    Version:          1.1.12
    GitCommit:        v1.1.12-0-g51d5e94
  docker-init:
    Version:          0.19.0
    GitCommit:        de40ad0

  ```


## 设置镜像加速源

执行
```sh
cat>> /etc/docker/daemon.json <<EOF
{
  "data-root": "/data/.docker",
  "exec-opts": ["native.cgroupdriver=systemd"],
  "registry-mirrors": [
    "https://hub-mirror.c.163.com", 
    "https://mirror.baidubce.com"
  ]
}
EOF

cat /etc/docker/daemon.json
systemctl restart docker
```

设置网络
```sh
cat>> /etc/sysctl.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sysctl -p
```


## 安装 Docker-Compose
```sh
# curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o docker-compose
curl -L "https://github.com/docker/compose/releases/download/2.24.5/docker-compose-$(uname -s)-$(uname -m)" -o docker-compose

sudo chown root:root ./docker-compose
sudo chmod 755 ./docker-compose
sudo ./docker-compose version
mv -f docker-compose /usr/local/bin/docker-compose
```


## 运行测试镜像
```sh
docker run --rm hello-world
docker run --rm alpine uname -a
# docker run --rm centos uname -a
docker images
```


---
资源
- [测试国内 Docker 镜像仓库有效性](https://github.com/docker-practice/docker-registry-cn-mirror-test/actions)
- [install-machine](https://docs.docker.com/machine/install-machine/#install-machine-directly)
- https://store.docker.com/editions/community/docker-ce-server-centos
- https://docs.docker.com/engine/installation/linux/docker-ce/centos/
- https://docs.docker.com/compose/compose-file/#sysctls


