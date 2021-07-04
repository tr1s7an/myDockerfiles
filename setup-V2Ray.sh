#!/bin/sh

mkdir /tmp/v2ray
curl -sL https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip -o /tmp/v2ray/v2ray.zip
unzip /tmp/v2ray/v2ray.zip -d /tmp/v2ray
install -m 755 /tmp/v2ray/v2ray /usr/local/bin/v2ray
install -m 755 /tmp/v2ray/v2ctl /usr/local/bin/v2ctl
rm -rf /tmp/v2ray

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
                "address": "https+local://1.0.0.1/dns-query",
                "port": 443
            }
        ]
    },
    "inbounds": [
        {
            "listen": "127.0.0.1",
            "port": 8081,
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "$UUID",
                        "level": 0
                    }
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "ws",
                "security": "none",
                "wsSettings": {
                    "path": "$WSPATH"
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

/usr/local/bin/v2ray -config /usr/local/etc/v2ray/config.json
