#!/bin/sh
set -e
# 更新证书

# wget https://curl.haxx.se/ca/cacert.pem
# cat ca.pem >> /etc/ssl/cert.pem
# ls -al /private/etc/ssl/cert.pem
# ls -al /etc/local/etc/openssl/cert.pem
# ls -al /etc/openssl/cert.pem

# brew info openssl
# /usr/local/opt/openssl/bin/openssl version
# cp cacert.pem /usr/local/etc/openssl@3/certs
# /usr/local/opt/openssl@3/bin/c_rehash

wget -O /etc/pki/ca-trust/source/anchors/ca-bundle.pem https://curl.haxx.se/ca/cacert.pem
update-ca-trust


