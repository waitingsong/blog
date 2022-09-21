#!/bin/sh
set -e

# 安装开发环境

export GEM="https://mirrors.tuna.tsinghua.edu.cn/rubygems/"
gem sources --add $GEM
gem sources --remove https://rubygems.org/
gem sources -l
# gem sources --remove $GEM

ruby -v
gem -v
gem env
gem install cocoapods
# gem uninstall cocoapods
# gem install cocoapods -v 1.7.5
gem install xcpretty rspec

