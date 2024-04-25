#!/bin/bash
set -e


echo ==================== 修改 ssh 登录设置 ====================
sudo sh -c "sed -i 's/^\s*\(AllowUsers.*\)/# \1/' /etc/ssh/sshd_config"
sudo sh -c "sed -i 's/^\s*\(PubkeyAuthentication .*\)/# \1/' /etc/ssh/sshd_config"
sudo sh -c "echo 'PubkeyAuthentication yes' >> /etc/ssh/sshd_config"
sudo sh -c "echo 'AllowUsers git admin admin2 admins ci' >> /etc/ssh/sshd_config"
sudo sh -c "echo '' >> /etc/ssh/sshd_config"

echo ==================== 设置仅允许 Ed25519 算法证书 ====================
sudo sh -c "sed -i 's/\(^\s*HostKey.\+ssh_host_rsa_key\)/# \1/' /etc/ssh/sshd_config"
sudo sh -c "sed -i 's/\(^\s*HostKey.\+ssh_host_dsa_key\)/# \1/' /etc/ssh/sshd_config"
sudo sh -c "sed -i 's/\(^\s*HostKey.\+ssh_host_ecdsa_key\)/# \1/' /etc/ssh/sshd_config"
sudo sh -c "sed -i 's/^#\s*\(HostKey.\+ssh_host_ed25519_key\)/\1/' /etc/ssh/sshd_config"
sudo cp /etc/ssh/sshd_config{,.ok}

