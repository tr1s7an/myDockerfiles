#!/bin/bash

echo '===============Generating environment variables...==============='
echo "-e PORT=${PORT:=8080} \\" && export PORT=${PORT}
echo "-e FALLBACK=${FALLBACK:=$(echo dGVzdC5ub2Vyci5ldS5vcmcK | base64 -d)} \\" && export FALLBACK=${FALLBACK}
echo "-e UUID=${UUID:=$(/usr/local/bin/v2ctl uuid)} \\" && export UUID=${UUID}
echo "-e TROJANWSPATH=${TROJANWSPATH:=$(tr -dc a-z </dev/urandom | head -c 10)} \\" && export TROJANWSPATH=${TROJANWSPATH}
echo "-e VMESSWSPATH=${VMESSWSPATH:=$(tr -dc a-z </dev/urandom | head -c 10)} \\" && export VMESSWSPATH=${VMESSWSPATH}
echo "-e TROJANGRPCPATH=${TROJANGRPCPATH:=$(tr -dc a-z </dev/urandom | head -c 10)} \\" && export TROJANGRPCPATH=${TROJANGRPCPATH}
echo '============================Done================================='

export TROJANWS_DOMAIN_SOCKET_FILE='/var/run/trojanws.sock'
export VMESSWS_DOMAIN_SOCKET_FILE='/var/run/vmessws.sock'
export TROJANGRPC_DOMAIN_SOCKET_FILE='/var/run/trojangrpc.sock'
rm -f ${TROJANWS_DOMAIN_SOCKET_FILE} ${VMESSWS_DOMAIN_SOCKET_FILE} ${TROJANGRPC_DOMAIN_SOCKET_FILE}

for f in /root/setup-configuration/setup-*.sh; do bash "${f}"; done

/usr/local/bin/v2ray -config /usr/local/etc/v2ray/config.json &
/usr/sbin/haproxy -f /usr/local/etc/haproxy/haproxy.cfg
