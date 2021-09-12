#!/bin/bash

install -d /usr/local/etc/v2ray
cat << EOF > /usr/local/etc/v2ray/config.json
{
    "log": {
        "access": "none",
        "loglevel": "error"
    },
    "inbounds": [
        {
            "listen": "${VMESS_DOMAIN_SOCKET_FILE}",
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "${UUID}",
                        "alterId": 0,
                        "security": "auto"
                    }
                ]
            },
            "streamSettings": {
                "network": "ws",
                "security": "none",
                "wsSettings": {
                    "path": "/${MYPATH}",
                    "maxEarlyData": 2048
                }
            }
        },
        {
            "listen": "${TROJAN_DOMAIN_SOCKET_FILE}",
            "protocol": "trojan",
            "settings": {
                "clients": [
                    {
                        "password": "${UUID}"
                    }
                ]
            },
            "streamSettings": {
                "network": "grpc",
                "security": "none",
                "grpcSettings": {
                    "serviceName": "${MYPATH}"
                }
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom",
            "settings": {
                "domainStrategy": "AsIs"
            }
        }
    ]
}
EOF
