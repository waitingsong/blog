# Node.js Docker 极致构建缓存策略

Node.js 项目 Docker 镜像容量从 1GB 到 70MB 的构建优化实践

## 常见构建镜像缓存方案

```
# Dockerfile

FROM node:lts-alpine

WORKDIR /app

COPY package.json .
RUN npm i

COPY . .
RUN npm run build \
  && npm prune --prod
```

优点：
- 若 `package.json` 文件无变化则 `npm i ` 依赖安装层可以缓存复用，从而缩短整体构建时间

缺点：
- 若 `package.json` 文件变化（执行了发版）则后续所有操作将不会复用缓存。但是实际上项目的依赖（无论开发还是生产依赖）很有可能是没有变化的


## 初级优化

### 1. 在 `Dockerfile` 构建外部安装依赖并进行项目编译  

可利用 CI 的缓存功能缓存 `package-lock.json` 文件加速依赖安装

```sh
npm i 
npm run build
rm node_modules -rf
npm i --prod --no-audit --no-optional
cd node_modules 
rm .package-lock.json -f
find . -type f -iname "package-lock.json" -print0 | xargs -0i rm -f {}
find . -type f -iname ".package-lock.json" -print0 | xargs -0i rm -f {}
cd -
```

### 2. 构建镜像首先拷贝 `node_modules` 依赖目录

```
# Dockerfile
FROM node:lts-alpine

WORKDIR /app

COPY node_modules ./node_modules
COPY dist ./dist
COPY package.json README.md .
```


## 高级优化

### 1. 精简基础镜像

- 使用国内镜像源替换 alpine 官方源
- 仅安装 nodejs 运行环境，不安装 `NPM` 和 `Yarn`  
  启动此镜像的服务不支持 `npm run start` 类似命令， 必须使用 `node` 命令，比如
  ```sh
  node bootstrap.js
  ```

基础镜像容量从 117MB 缩减到 50MB

![](./image/images-node.png)

```
# Dockerfile

FROM alpine:3.14

ENV NODE_VERSION 14.17.6
ENV MIRROR=https://mirrors.sjtug.sjtu.edu.cn
# ENV MIRROR=https://mirrors.ustc.edu.cn

# https://github.com/nodejs/docker-node/blob/main/14/alpine3.14/docker-entrypoint.sh
COPY docker-entrypoint.sh /usr/local/bin/  

RUN chmod a+x /usr/local/bin/docker-entrypoint.sh \
  && cat /etc/alpine-release \
  && NODE_DIST="https://npm.taobao.org/dist" \
  && sed -i "s#https://dl-cdn.alpinelinux.org#$MIRROR#g" /etc/apk/repositories \
  && echo "@edge $MIRROR/alpine/edge/main" >> /etc/apk/repositories \
  && apk upgrade --no-cache \
  && addgroup -g 1000 node \
  && adduser -u 1000 -G node -s /bin/sh -D node \
  && apk add --no-cache curl nodejs@edge=~$NODE_VERSION \
  && node --version \
  && rm /var/cache/apk/* /var/lib/apt/lists/* /tmp/* /var/tmp/* -rf

ENTRYPOINT ["docker-entrypoint.sh"]
CMD [ "node" ]  
```

### 2. 对 `node_modules` 依赖进行分组

