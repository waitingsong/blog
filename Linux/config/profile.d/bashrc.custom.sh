#!/bin/sh
# cp -u bashrc.custom.sh /etc/profile.d/

export REG1='foo'

export XZ_DEFAULTS='-T 0'
export ZSTD_CLEVEL=9

export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if [[ -x "$(command -v npm)" ]]; then
  if [[ "$(npm config get registry)" != "https://registry.npmmirror.com" ]]; then
    npm config -g set registry https://registry.npmmirror.com
  fi
fi

df -lhT

# vim:ts=4:sw=4
