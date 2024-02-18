#!/bin/sh
set -e

ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519
sudo sh -c "ssh-keygen -t ed25519 -N '' -f /root/.ssh/id_ed25519"

