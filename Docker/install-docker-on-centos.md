# CentOS 7/8 安装 Docker-CE


## 安装依赖
```sh
dnf install -y device-mapper-persistent-data lvm2

#dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
dnf config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

#dnf install https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.13-3.2.el7.x86_64.rpm
dnf install https://mirrors.aliyun.com/docker-ce/linux/centos/7/x86_64/edge/Packages/containerd.io-1.3.7-3.1.el7.x86_64.rpm

mkdir -p /data/.docker /data/docker /etc/docker
chown root:root /data/.docker
chown docker:docker /data/docker
chmod 775 /data/docker
```

## 安装

- 最新版
  ```sh
  dnf install docker-ce docker-ce-cli 
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
   Version:           19.03.13
   API version:       1.40
   Go version:        go1.13.15
   Git commit:        4484c46d9d
   Built:             Wed Sep 16 17:03:45 2020
   OS/Arch:           linux/amd64
   Experimental:      false

  Server: Docker Engine - Community
   Engine:
    Version:          19.03.13
    API version:      1.40 (minimum version 1.12)
    Go version:       go1.13.15
    Git commit:       4484c46d9d
    Built:            Wed Sep 16 17:02:21 2020
    OS/Arch:          linux/amd64
    Experimental:     false
   containerd:
    Version:          1.3.7
    GitCommit:        8fba4e9a7d01810a393d5d25a3621dc101981175
   runc:
    Version:          1.0.0-rc10
    GitCommit:        dc9208a3303feef5b3839f4323d9beb36df0a9dd
   docker-init:
    Version:          0.18.0
    GitCommit:        fec3683
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
    "https://docker.mirrors.ustc.edu.cn",
    "https://mirror.baidubce.com"
  ]
}
EOF

cat /etc/docker/daemon.json
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
curl -L "https://github.com/docker/compose/releases/download/1.27.7/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chown root:root /usr/local/bin/docker-compose
chmod 755 /usr/local/bin/docker-compose
```


## 运行测试镜像
```sh
docker run --rm hello-world
docker run --rm alpine uname -a
docker run --rm centos uname -a
docker images
```


---
资源
- [测试国内 Docker 镜像仓库有效性](https://github.com/docker-practice/docker-registry-cn-mirror-test/actions)
- [install-machine](https://docs.docker.com/machine/install-machine/#install-machine-directly)
- https://store.docker.com/editions/community/docker-ce-server-centos
- https://docs.docker.com/engine/installation/linux/docker-ce/centos/
- https://docs.docker.com/compose/compose-file/#sysctls


