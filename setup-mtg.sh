#!/bin/sh

mtgsecret=$(cat ~/mtgsecret)
install -d /usr/local/etc/mtg
cat << EOF > /usr/local/etc/mtg/config.toml
secret = "$mtgsecret"
bind-to = "127.0.0.1:8082"
prefer-ip = "prefer-ipv6"
EOF
