<center>Linux 安装 Node.js</center>

- 安装nvm 管理器
  ```sh
  cd /usr/local/src/
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
  . ~/.bashrc
  ```

- 查看远程服务器所有可安装 node.js 版本
  `nvm ls-remote`

- 安装 node.js LTS 最新版本
  `nvm install 18.0`
  `nvm use 18.0`

- 安装 nrm 仓库管理器
  `npm -g nrm`

- （备选）替换npm源为淘宝镜像源:
  `npm config set registry https://registry.npmmirror.com`

- 恢复默认 npm 源
  `npm config set registry https://registry.npmjs.org`



https://github.com/nvm-sh/nvm
