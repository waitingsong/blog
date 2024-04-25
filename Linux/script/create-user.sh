#!/bin/sh
set -e
user=$1

if [[ $user == "" ]]; then
  echo "Usage: $0 <user>"
  exit 1
fi

echo -e "--------- create user: $user --------- "

useradd  ${user}
pwgen -s 64 1 | passwd ${user} --stdin

sudo -u ${user} sh -c "ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519"

