#!/bin/bash

install -d /usr/local/etc/myapp
cat << EOF > /usr/local/etc/myapp/config.json
{
    "inbounds": [
        {
            "listen": "@${TROJANWS_DOMAIN_SOCKET_FILE}",
            "protocol": "trojan",
            "settings": {
                "users": [
                    "${UUID}"
                ]
            },
            "streamSettings": {
                "transport": "ws",
                "transportSettings": {
                    "path": "/${TROJANWSPATH}",
                    "maxEarlyData": 2048
                },
                "security": "none",
                "securitySettings": {}
            }
        },
        {
            "listen": "@${VMESSWS_DOMAIN_SOCKET_FILE}",
            "protocol": "vmess",
            "settings": {
                "users": [
                    "${UUID}"
                ]
            },
            "streamSettings": {
                "transport": "ws",
                "transportSettings": {
                    "path": "/${VMESSWSPATH}",
                    "maxEarlyData": 2048
                },
                "security": "none",
                "securitySettings": {}
            }
        },
        {
            "listen": "@${TROJANGRPC_DOMAIN_SOCKET_FILE}",
            "protocol": "trojan",
            "settings": {
                "users": [
                    "${UUID}"
                ]
            },
            "streamSettings": {
                "transport": "grpc",
                "transportSettings": {
                    "serviceName": "${TROJANGRPCPATH}"
                },
                "security": "none",
                "securitySettings": {}
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom"
        }
    ]
}
EOF
