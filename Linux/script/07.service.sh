#!/bin/bash
set -e


# 开启相关服务

# 计划任务
systemctl enable --now crond


