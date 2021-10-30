#!/bin/bash

function check_configuration() {
        if ! [ -v "$1" ] ; then
                target=$(eval "$2")
		eval "export $1=${target}"
		echo -e "-e $1=\"${target}\" \\"
        fi
}
function check_process() {
	while sleep 60; do
		for p in ${@}
		do
			ps aux |grep ${p} |grep -q -v grep
			PROCESS_STATUS=$?
			if [ ${PROCESS_STATUS} -ne 0 ]; then
				echo "${p} has already exited."
			fi
		done
	done
}
function clean_socket_file() {
	for f in ${@} 
	do
		if [ -S ${f} ]; then
			rm -f "${f}"*
		fi
	done
}

echo '===============Generating environment variables...==============='
check_configuration "PORT" "echo 8080"
check_configuration "FALLBACK" "echo dGVzdC5ub2Vyci5ldS5vcmcK | base64 -d"
check_configuration "UUID" "/usr/local/bin/v2ctl uuid"
check_configuration "MAINPATH" "tr -dc a-z </dev/urandom | head -c 6" 
check_configuration "VMESSPATH" "tr -dc a-z </dev/urandom | head -c 6" 
check_configuration "TROJANPATH" "tr -dc a-z </dev/urandom | head -c 6" 
check_configuration "mtgsni" "echo www.bilibili.com"
check_configuration "mtgsecret" "/usr/local/bin/mtg generate-secret --hex ${mtgsni}"
check_configuration "password" "tr -dc A-Za-z0-9 </dev/urandom | head -c 16"
echo '============================Done================================='

# Clean v2ray socket file
export MAIN_DOMAIN_SOCKET_FILE="/var/run/main.sock"
export VMESS_DOMAIN_SOCKET_FILE="/var/run/vmess.sock"
export TROJAN_DOMAIN_SOCKET_FILE="/var/run/trojan.sock"
clean_socket_file "${MAIN_DOMAIN_SOCKET_FILE}" "${VMESS_DOMAIN_SOCKET_FILE}" "${TROJAN_DOMAIN_SOCKET_FILE}"

# Run all setup shell scripts
for f in /root/setup-configuration/setup-*.sh; do
  bash "${f}"
done

# Run wireguard
if [ "${ENABLE_WG}" = 'yes' ]; then
	echo '===================Configuring wireguard...======================'
	check_configuration "serverprikey" "wg genkey"
	check_configuration "clientprikey" "wg genkey"
	export serverpubkey=$(echo ${serverprikey} |wg pubkey)
	export clientpubkey=$(echo ${clientprikey} |wg pubkey)
	echo "serverpubkey=${serverpubkey}"
	echo "clientpubkey=${clientpubkey}"
	export interface_name='wg0'
	bash /root/setup-configuration/optional-setup-wg.sh
	wg-quick up ${interface_name}
	echo '============================Done================================='
else
	echo 'Wireguard will not start'
fi

/usr/local/bin/v2ray -config /usr/local/etc/v2ray/config.json &
/usr/local/bin/mtg run /usr/local/etc/mtg/config.toml &
/usr/sbin/haproxy -f /usr/local/etc/haproxy/haproxy.cfg &
/usr/local/bin/ssserver --config /usr/local/etc/shadowsocks-rust/config.json & 
check_process "v2ray" "mtg" "haproxy" "ssserver"
