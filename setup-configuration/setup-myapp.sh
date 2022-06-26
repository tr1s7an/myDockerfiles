#!/bin/bash

install -d /usr/local/etc/myapp
cat << EOF > /usr/local/etc/myapp/config.json
{
    "inbounds": [
        {
            "listen": "127.0.0.1", 
            "port": ${TROJANWSPORT},
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
            "listen": "127.0.0.1", 
            "port": ${VMESSWSPORT},
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
            "listen": "127.0.0.1", 
            "port": ${TROJANGRPCPORT},
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
