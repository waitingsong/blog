#!/bin/sh
set -e

# 安装应用


brew install openssl openssh
brew install bash fd jq gnu-sed gnu-tar wget zstd
brew install nodejs ruby oclint
brew install htop mtr

brew install bash-completion
# Add the following line to your ~/.bash_profile:
#   [[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

npm -i g zx

