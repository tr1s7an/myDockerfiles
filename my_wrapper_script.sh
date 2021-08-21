#!/bin/bash

function check_configuration() {
        if ! [ -v "$1" ] ; then
                target=$(eval "$2")
		eval "export $1=${target}"
		echo -e "-e $1=\"${target}\" \\"
        fi
}
function start_process() {
	eval "$1" & 
	status=$?
	if [ ${status} -ne 0 ]; then
		echo "Failed to start $2: ${status}"
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

check_configuration "UUID" "/usr/local/bin/v2ctl uuid"
check_configuration "WSPATH" "tr -dc a-z </dev/urandom | head -c 6" 
check_configuration "mtgsni" "echo www.bilibili.com"
check_configuration "mtgsecret" "/usr/local/bin/mtg generate-secret --hex ${mtgsni}"
check_configuration "password" "tr -dc A-Za-z0-9 </dev/urandom | head -c 16"

for f in /root/setup-configuration/*.sh; do
  bash "${f}"
done

start_process "/usr/local/bin/v2ray -config /usr/local/etc/v2ray/config.json" "v2ray"
start_process "/usr/local/bin/mtg run /usr/local/etc/mtg/config.toml" "mtg"
start_process "/usr/sbin/haproxy -f /usr/local/etc/haproxy/haproxy.cfg" "haproxy"
start_process "/usr/local/bin/ssserver -s 127.0.0.1:8083 -m aes-128-gcm -k ${password}" "ssserver"

check_process "v2ray" "mtg" "haproxy" "ssserver"
