#!/bin/bash
set +e


cwd=$(pwd)

pkgs=`find . -mindepth 1 -maxdepth 1 `

for pkg in $pkgs
do
  name=$(echo "$pkg" | awk -F'/' '{print $2}')

  if [ "$name" == ".git" ]; then
    continue
  fi
  if [ "$name" == ".githooks" ]; then
    continue
  fi

  path="$cwd/$name"
  if [ ! -d "$path" ]; then
    continue
  fi

  echo path: $path
  chmod a+x -R "$path"

  find "$path" -type f -iname "*.sh" -print0 \
    | xargs -0II git update-index --ignore-missing --chmod=+x I

  find "$path" -type f -iname "*.mjs" -print0 \
    | xargs -0II git update-index --ignore-missing --chmod=+x I

done

echo "Commit changes if changed!"
set -e

