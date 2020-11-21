# Docker 常用操作


使用 `docker images` 查看本机已有的镜像  

命令格式：`docker save 镜像名|commit id`
- 指定镜像名保存，带有镜像 repo 及 tab 信息，load 加载后将会保持原有 tag 信息
- 指定 hash 值导出的镜像加载后没有名称和 tag

保存正在运行的容器为镜像： `docker commit <CONTAIN-ID> <IMAGE-NAME>`

```bash
export XZ_DEFAULTS="-T 0 -4"
export ZSTD_CLEVEL=10

docker save hello-world > /tmp/hello.tar
docker load -i /tmp/hello.tar
docker load < /tmp/hello.tar

docker save centos -o /tmp/hello.tar
time sh -c 'docker save centos | xz > /tmp/centos.xz'
time sh -c 'docker save centos | zstdmt > /tmp/centos.zst'
```

获得容器 id
```sh
docker container ls
```

根据获得的容器 id 查询健康度
```sh
docker inspect --format '{{json .State.Health}}' 4955 | jq
```

