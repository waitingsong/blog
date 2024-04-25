#!/bin/bash
set -e


echo ==================== 开启相关服务 ====================

echo ">> 计划任务"
systemctl enable --now crond

