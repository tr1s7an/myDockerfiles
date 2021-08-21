#!/bin/bash

install -d /usr/local/etc/v2ray
cat << EOF > /usr/local/etc/v2ray/config.json
{
    "log": {
        "access": "none",
        "loglevel": "error"
    },
    "dns": {
        "servers": [
            {
                "address": "https+local://cloudflare-dns.com/dns-query",
                "port": 443
            }
        ]
    },
    "inbounds": [
        {
            "listen": "127.0.0.1",
            "port": 8081,
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "$UUID",
                        "alterId": 0,
                        "security": "auto"

                    }
                ]
            },
            "streamSettings": {
                "network": "ws",
                "security": "none",
                "wsSettings": {
                    "path": "/$WSPATH"
                }
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom",
            "settings": {
                "domainStrategy": "UseIP"
            }
        }
    ]
}
EOF
