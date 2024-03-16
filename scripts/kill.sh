#!/bin/bash

if [ -z "$1" ]; then
  echo "No process name provided. Please provide a valid process name."
  exit 1
fi

# 判断是否有路径包含 "$1" 的进程
# pid=$(pgrep -f "$1")
pid=$(pgrep -f "$1" | sort -n | head -1)

if [[ -n "$pid" ]]; then
  echo -e "发现包含 '$1' 的进程：$pid"

  # 杀掉进程及其子进程
  sudo pkill -TERM -P $pid
  sudo kill $pid

  echo "已成功杀掉进程及其子进程。"
else
  echo "未发现包含 'bigscreen' 的进程。"
fi
~
