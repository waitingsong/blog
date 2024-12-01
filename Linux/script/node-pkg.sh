#!/bin/sh
set -e
user=$( whoami )

echo -e "--------- install node pkgs for $user --------- "

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# if [[ ! -x "$(command -v npm)" ]]; then
#   echo -e "--------- install node for $user. --------- "
#   nvm install --lts
#   nvm use --lts
# fi

npm -g config set registry https://registry.npmmirror.com
# npm -g config set registry https://mirrors.tencent.com/npm
npm i -g nrm
nrm use taobao

npm i -g \
  @commitlint/cli \
  c8 \
  eslint \
  lerna \
  madge \
  rollup \
  zx \
  tsx \


