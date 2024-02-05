<center>Linux 安装 Node.js</center>

- 安装nvm 管理器
  ```sh
  cd /usr/local/src/
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
  . ~/.bashrc
  ```

- 查看远程服务器所有可安装 node.js 版本
  `nvm ls-remote`

- 安装 node.js LTS 最新版本
  ```sh
  export NVM_NODEJS_ORG_MIRROR=https://nodejs.org/dist
  export NVM_NODEJS_ORG_MIRROR=https://npmmirror.com/dist/
  ```
  `nvm install --lts`
  `nvm use lts`

- 安装 nrm 仓库管理器
  `npm i -g nrm`

- （备选）替换npm源为淘宝镜像源:
  `npm config set registry https://registry.npmmirror.com`

- 恢复默认 npm 源
  `npm config set registry https://registry.npmjs.org`



https://github.com/nvm-sh/nvm

全系统： [通过包管理器方式安装 Node.js](https://nodejs.org/zh-cn/download/package-manager)