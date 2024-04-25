#!/bin/sh
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
user=$( whoami )

export NVM_DIR="$HOME/.nvm"

rm -rf $NVM_DIR

if [[ ! -d $NVM_DIR ]]; then
  echo -e "--------- install nvm for $user --------- "
  # /usr/local/nvm/install.sh
  cp -a /usr/local/nvm ${NVM_DIR}
fi

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if [[ ! -x "$(command -v npm)" ]]; then
  echo -e "--------- install node for $user --------- "
  # nvm install 18
  # nvm use 18
  # nvm uninstall --lts
  nvm install --lts
  nvm use --lts
fi

${DIR}/node-pkg.sh

