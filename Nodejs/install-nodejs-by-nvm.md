# windows下用 nvm 安装node

## 下载 nvm 安装包 [nvm-setup.zip](https://github.com/coreybutler/nvm-windows/releases)

## 执行 nvm-setup.exe 安装程序
可全部采用默认值

## 修改 nvm 配置文件
打开程序安装目录下文件 settings.txt 追加以下两个 mirror 配置项目，如下
```
root: c:\nvm
path: c:\nodejs
arch: 64
proxy: none
node_mirror: https://npmmirror.com/mirrors/node/
npm_mirror: https://npmmirror.com/mirrors/npm/
```
  - root ： nvm的安装地址
  - path ： 存放指向node版本的快捷方式，使用nvm的过程中会自动生成。一般写的时候与nvm同级。
  - arch ： 电脑系统是64位就写64,32位就写32
  - proxy ： 代理

## 检测安装结果
打开控制台，执行命令 ```nvm```, 若是出现版本信息以及参数帮助，则安装成功。

## 安装 Node.js
控制台执行 ```nvm install <版本号>``` 安装指定版本，版本号格式 x.y.z 
比如执行 ```nvm install 18.0.0```

## 切换指定 Node.js 版本
控制台执行 ```nvm use 18.0.0```

## 查看已安装 Node.js 版本
控制台执行 ```nvm list```
