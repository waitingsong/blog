#!/bin/sh
set -e

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

npm -g config set registry https://registry.npmmirror.com
npm i -g nrm
nrm use taobao

npm -g update
