

## 常用全局包
```sh

npm i -g --loglevel=info \
  nrm

nrm use taobao

npm i -g --loglevel=info \
  @commitlint/cli \
  c8 \
  eslint \
  lerna \
  nx \
  rollup \
  typescript \
  node-gyp \
  zx \
  ts-node \
  tsx \


  gitlab-var-helper-cli \
  myca-cli \
  form-data \
  kmore-cli \

  midway-init \
  plugman karma \
  npm-remote-ls \
  gulp@3.9.1 \

```

确认已安装 `.NET Framework 4.5+`. 安装vs编译环境，
以**管理员**权限cmd执行
```
npm i -g --production windows-build-tools --vs2015
```
然后执行 ``
查看执行结果
```
npm config set msvs_version 2017 --global
npm config get msvs_version
```

若要安装vs2017版本则 `npm i -g --production windows-build-tools --vs2017`
或者直接安装 VS 正式版本
https://npm.taobao.org/mirrors
```
set "PYTHON_MIRROR=https://npm.taobao.org/mirrors/python" && npm i -g --production windows-build-tools
```

```
cd <project>/node_modules/ffi
node-gyp configure --verbose
node-gyp configure --verbose --msvs_version=2017
node-gyp configure --msvs_version=2017
node-gyp rebuild --verbose
```



## 项目相关包
```sh
npm i --save-dev @types/ffi  @types/mocha @types/node @types/power-assert @types/ref
npm i --save-dev @types/ref-struct coveralls eslint intelli-espower-loader istanbul mocha mocha-lcov-reporter
npm i --save-dev nyc power-assert rimraf source-map-support ts-node tslint
npm i --save-dev mz-modules
```

## ionic 相关包
```sh
npm i -g --loglevel=info \
  @angular/cli \
  @angular/animations @angular/common @angular/core @angular/forms \
  cordova ionic \
  cordova-res native-run \
  @ionic/angular-toolkit \
```


## （备选）设置 npm 仓库为 taobao 镜像
- `npm config set registry https://registry.npm.taobao.org`
- `nrm use taobao`


## 使用 nrm 添加切换公司源
```sh
# 切换私服公司源
nrm add central https://nexus.sundsoft.com/repository/npm-central/
nrm use central
# 切换私服淘宝源
nrm add central-taobao https://nexus.sundsoft.com/repository/npm-taobao/
nrm use central-taobao
# 切换官方淘宝源
nrm use taobao
# 切换npm官方库
nrm use npm

# 切换私服私有库
nrm add mynpm https://nexus.sundsoft.com/repository/mynpm/
nrm use mynpm
```

## 卸载 cnpm 扩展
`npm uninstall cnpm -g`

## 清除 npm 缓存
`npm cache clean --force`

[仅参考-手动安装 npm 5.6.0](https://github.com/coreybutler/nvm-windows/issues/300)

## 恢复仓库默认源
`npm config set registry https://registry.npmjs.org`

## 登录

- npm 官方
  ```sh
  nrm use npm
  npm login
  # 等同命令 
  npm adduser
  ```
- 私有库
  ```sh
  nrm use central
  npm login
  ```

## 发布到私有库
  ```sh
  npm publish --registry https://localhost:4873
  ```

- gyp 安装疑难
    - `node-gyp configure --verbose`  https://github.com/nodejs/node-gyp/issues/1278

- 查看依赖 `npm ls`

- 查看依赖树 `npm-remote-ls browser`


## 查看 npm 包信息
https://stackoverflow.com/questions/33530978/download-a-package-from-npm-as-a-tar-not-installing-it-to-a-module
```sh
npm view @bfa/uc-test
npm view @bfa/uc-test dist.tarball
```

## 下载指定 npm 发布包
```sh
npm pack @bfa/uc-test
```

## 扩展 nodejs CA 证书
```sh
export NODE_EXTRA_CA_CERTS="c:/ca-ec.crt"
```


https://github.com/nodejs/node-gyp/issues/1278
>>>
I had to choose these under "Individual Components" in the VS2017 installer:

    Windows 10 SDK (10.0.16299.0) for UWP: C#, VB, JS
    Windows 10 SDK (10.0.16299.0) for UWP: C++
    Windows 10 SDK (10.0.16299.0) for Desktop C++ [x86 and x64]
    Visual Studio C++ core features
    VC++ 2017 v141 toolset (x86,x64)`
>>>


npm -g root

临时改变控制台代码页
```sh
chcp.com 65001
chcp.com 936
```


重新生成日志
```sh
npm i -D conventional-changelog-cli

conventional-changelog \
  --preset angular \
  --infile CHANGELOG.md \
  --same-file \
  --release-count 0 \

```


git设置代理
```sh
git config --global http.proxy  'socks5://127.0.0.1:7890'
git config --global https.proxy 'socks5://127.0.0.1:7890'
```

git显示代理
```sh
git config http.proxy
git config https.proxy
```

git取消代理
```sh
git config --global --unset http.proxy
git config --global --unset https.proxy
```

~/.ssh/config
```
Host github.com
  user git
  identityFile ~/.ssh/id_ed25519
  # for windows:
  #proxycommand "/c/Program Files/Git/mingw64/bin/connect.exe" -a none -S 127.0.0.1:7890 %h %p

  # for CentOS
  #proxycommand connect-proxy -S 127.0.0.1:7890 %h %p

  # for linux
  #proxycommand nc -X connect -x 127.0.0.1:7890 %h %p
```


OR Enabling SSH connections over HTTPS
https://docs.github.com/en/authentication/troubleshooting-ssh/using-ssh-over-the-https-port
