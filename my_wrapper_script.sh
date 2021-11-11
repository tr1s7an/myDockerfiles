#!/bin/bash

echo '===============Generating environment variables...==============='
echo "-e PORT=${PORT:=8080} \\" && export PORT=${PORT}
echo "-e FALLBACK=${FALLBACK:=$(echo dGVzdC5ub2Vyci5ldS5vcmcK | base64 -d)} \\" && export FALLBACK=${FALLBACK}
echo "-e UUID=${UUID:=$(/usr/local/bin/v2ctl uuid)} \\" && export UUID=${UUID}
echo "-e MAINPATH=${MAINPATH:=$(tr -dc a-z </dev/urandom | head -c 6)} \\" && export MAINPATH=${MAINPATH}
echo "-e VMESSPATH=${VMESSPATH:=$(tr -dc a-z </dev/urandom | head -c 6)} \\" && export VMESSPATH=${VMESSPATH}
echo "-e TROJANPATH=${TROJANPATH:=$(tr -dc a-z </dev/urandom | head -c 6)} \\" && export TROJANPATH=${TROJANPATH}
echo "-e mtgsni=${mtgsni:=www.bilibili.com} \\" && export mtgsni=${mtgsni}
echo "-e mtgsecret=${mtgsecret:=$(/usr/local/bin/mtg generate-secret --hex ${mtgsni})} \\" && export mtgsecret=${mtgsecret}
echo "-e password=${password:=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 16)} \\" && export password=${password}
echo '============================Done================================='

export MAIN_DOMAIN_SOCKET_FILE='/var/run/trojanws.sock'
export VMESS_DOMAIN_SOCKET_FILE='/var/run/vmessws.sock'
export TROJAN_DOMAIN_SOCKET_FILE='/var/run/trojangrpc.sock'
rm -f ${MAIN_DOMAIN_SOCKET_FILE} ${VMESS_DOMAIN_SOCKET_FILE} ${TROJAN_DOMAIN_SOCKET_FILE}

for f in /root/setup-configuration/setup-*.sh; do bash "${f}"; done

# Run wireguard
if [ "${ENABLE_WG}" = 'yes' ]; then
	echo '===================Configuring wireguard...======================'
	echo "-e serverprikey=${serverprikey:=$(wg genkey)} \\" && export serverprikey=${serverprikey}
	echo "-e clientprikey=${clientprikey:=$(wg genkey)} \\" && export clientprikey=${clientprikey}
	echo "-e serverpubkey=${serverpubkey:=$(echo ${serverprikey} |wg pubkey)} \\" && export serverpubkey=${serverpubkey}
	echo "-e clientpubkey=${clientpubkey:=$(echo ${clientprikey} |wg pubkey)} \\" && export clientpubkey=${clientpubkey}
	export interface_name='wg0'
	bash /root/setup-configuration/optional-setup-wg.sh
	wg-quick up ${interface_name}
	echo 'Wireguard has started'
	echo '============================Done================================='
else
	echo 'Wireguard will not start'
fi

/usr/local/bin/v2ray -config /usr/local/etc/v2ray/config.json &
/usr/local/bin/mtg run /usr/local/etc/mtg/config.toml &
/usr/local/bin/ssserver --config /usr/local/etc/shadowsocks-rust/config.json & 
/usr/sbin/haproxy -f /usr/local/etc/haproxy/haproxy.cfg
