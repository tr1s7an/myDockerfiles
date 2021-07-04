#!/bin/sh

mkdir /tmp/mtg
mtg_version=$(curl -s https://github.com/9seconds/mtg/releases/latest | grep -o '\/v[0-9].*[0-9]' | grep -o '[0-9].*[0-9]')
url="https://github.com/9seconds/mtg/releases/download/v${mtg_version}/mtg-${mtg_version}-linux-amd64.tar.gz"
curl -sL ${url} -o /tmp/mtg/mtg.tar.gz
tar -C /tmp/mtg -xf /tmp/mtg/mtg.tar.gz
install -m 755 /tmp/mtg/mtg-${mtg_version}-linux-amd64/mtg /usr/local/bin/mtg
rm -rf /tmp/mtg

install -d /usr/local/etc/mtg
cat << EOF > /usr/local/etc/mtg/config.toml
secret = "$mtgsecret"
bind-to = "127.0.0.1:8082"
prefer-ip = "prefer-ipv6"
EOF

/usr/local/bin/mtg run /usr/local/etc/mtg/config.toml
