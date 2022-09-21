#!/bin/bash
set -e


# VIM
cp ../config/.vimrc ~/


# 更新本地设置
cat>> ~/.profile <<EOF
export PATH="/usr/local/bin:\$PATH"
df -lhT
EOF


