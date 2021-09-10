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
            "listen": "${UNIX_DOMAIN_SOCKET_FILE}",
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
                    "path": "/${WSPATH}",
                    "maxEarlyData": 2048 
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
