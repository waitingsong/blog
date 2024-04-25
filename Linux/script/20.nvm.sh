#!/bin/sh
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo ${DIR}

echo ==================== 安装 nvm nodejs ====================

rm -rf /usr/local/nvm
if [[ ! -d /usr/local/nvm ]]; then
  # curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
  unzip -oq ../bin/nvm.zip -d /usr/local/
  cd /usr/local/nvm
  git reset --hard
  chmod a+x install.sh
fi

cd ${DIR}

sudo -u root ./install-nvm.sh
sudo -u admins ./install-nvm.sh
sudo -u admin ./install-nvm.sh
sudo -u ci ./install-nvm.sh

