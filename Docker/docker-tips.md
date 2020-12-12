# Docker 常用操作


使用 `docker images` 查看本机已有的镜像  

命令格式：`docker save 镜像名|commit id`
- 指定镜像名保存，带有镜像 repo 及 tab 信息，load 加载后将会保持原有 tag 信息
- 指定 hash 值导出的镜像加载后没有名称和 tag

保存正在运行的容器为镜像： `docker commit <CONTAIN-ID> <IMAGE-NAME>`

```sh
docker save hello-world > /tmp/hello.tar
docker save hello -o /tmp/hello.tar
docker load -i /tmp/hello.tar
docker load < /tmp/hello.tar
```


获得容器 id
```sh
docker container ls
```

根据获得的容器 id 查询健康度
```sh
docker inspect --format '{{json .State.Health}}' 4955 | jq
```


压缩解压缩性能测试
```sh
export XZ_DEFAULTS="-T 0 -2"
export ZSTD_CLEVEL=10

img=gitlab/gitlab-ce:13.6.2-ce.0
name=gitlab
time sh -c "docker save $img | xz > /tmp/$name.xz"
time sh -c "docker save $img | zstdmt > /tmp/$name-$ZSTD_CLEVEL.zst"
```

| type    | size (MB) | compress user time | decompress real time |
| ------- | --------- | ------------------ | -------------------- |
| xz -2   | 737       | 5m59.103s          | 0m26.274s            |
| xz -4   | 703       | 10m44.822s         | 0m25.609s            |
| xz -9   | 606       | 12m1.011s          | 0m22.428s            |
| zst -5  | 792       | 0m20.174s          | 0m2.224s             |
| zst -9  | 765       | 0m52.672s          | 0m2.050s             |
| zst -10 | 752       | 1m21.433s          | 0m1.988s             |
| zst -15 | 744       | 3m54.210s          | 0m2.006s             |
|         |           |                    |                      |


