#!/bin/bash

echo '===============Generating environment variables...==============='
echo "-e PORT=${PORT:=8080} \\" && export PORT=${PORT}
echo "-e FALLBACK=${FALLBACK:=$(echo ZGVtbzIubmV4dGNsb3VkLmNvbQo= | base64 -d)} \\" && export FALLBACK=${FALLBACK}
echo "-e UUID=${UUID:=$(/usr/local/bin/myapp uuid)} \\" && export UUID=${UUID}
echo "-e TROJANWSPATH=${TROJANWSPATH:=$(tr -dc a-z </dev/urandom | head -c 10)} \\" && export TROJANWSPATH=${TROJANWSPATH}
echo "-e VMESSWSPATH=${VMESSWSPATH:=$(tr -dc a-z </dev/urandom | head -c 10)} \\" && export VMESSWSPATH=${VMESSWSPATH}
echo "-e TROJANGRPCPATH=${TROJANGRPCPATH:=$(tr -dc a-z </dev/urandom | head -c 10)} \\" && export TROJANGRPCPATH=${TROJANGRPCPATH}
echo '============================Done================================='

export TROJANWSPORT=$(shuf -i 40001-41000 -n 1)
export VMESSWSPORT=$(shuf -i 41001-42000 -n 1)
export TROJANGRPCPORT=$(shuf -i 42001-43000 -n 1)

for f in /root/setup-configuration/setup-*.sh; do bash "${f}"; done

/usr/local/bin/myapp run -config /usr/local/etc/myapp/config.json -format jsonv5 &
/usr/sbin/haproxy -f /usr/local/etc/haproxy/haproxy.cfg
