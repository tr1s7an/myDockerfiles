#!/bin/bash

install -d /usr/local/etc/shadowsocks-rust
cat << EOF > /usr/local/etc/shadowsocks-rust/config.json
{
    "servers": [
        {
            "server": "0.0.0.0",
            "server_port": 8083,
            "password": "${password}",
            "method": "aes-128-gcm",
            "mode": "tcp_and_udp"
        }
    ]
}
EOF

