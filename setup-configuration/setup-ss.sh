#!/bin/bash

install -d /usr/local/etc/shadowsocks-rust
cat << EOF > /usr/local/etc/shadowsocks-rust/config.json
{
    "servers": [
        {
            "server": "127.0.0.1",
            "server_port": 8083,
            "password": "${password}",
            "method": "aes-128-gcm"
        },
        {
            "server": "0.0.0.0",
            "server_port": 18080,
            "password": "${password}",
            "method": "aes-128-gcm",
            "mode": "tcp_and_udp"
        }
    ]
}
EOF

