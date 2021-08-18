#!/bin/sh

[ -z "${UUID}" ] && UUID=$(/usr/local/bin/v2ctl uuid)
echo "UUID -> ${UUID}" && echo ${UUID} > ~/UUID
[ -z "${WSPATH}" ] && WSPATH=$(tr -dc a-z </dev/urandom | head -c 6) && WSPATH="/${WSPATH}"
echo "WSPATH -> ${WSPATH}" && echo ${WSPATH} > ~/WSPATH
[ -z "${mtgsni}" ] && mtgsni='www.bilibili.com'
echo "mtgsni -> ${mtgsni}" && echo ${mtgsni} > ~/mtgsni
[ -z "${mtgsecret}" ] && mtgsecret=$(/usr/local/bin/mtg generate-secret --hex ${mtgsni})
echo "mtgsecret -> ${mtgsecret}" && echo ${mtgsecret} > ~/mtgsecret
[ -z "${password}" ] && password=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 16)
echo "password -> ${password}" && echo ${password} > ~/password

/root/setup-v2ray.sh
/usr/local/bin/v2ray -config /usr/local/etc/v2ray/config.json &
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start setup-v2ray.sh: $status"
  exit $status
fi

/root/setup-mtg.sh
/usr/local/bin/mtg run /usr/local/etc/mtg/config.toml &
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start setup-mtg.sh: $status"
  exit $status
fi

/root/setup-haproxy.sh
/usr/sbin/haproxy -f /usr/local/etc/haproxy/haproxy.cfg &
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start setup-haproxy.sh: $status"
  exit $status
fi
 
/usr/local/bin/ssserver -s "127.0.0.1:8083" -m "aes-128-gcm" -k "${password}" &
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start ssserver: $status"
  exit $status
fi

# Naive check runs checks once a minute to see if either of the processes exited.
# This illustrates part of the heavy lifting you need to do if you want to run
# more than one service in a container. The container exits with an error
# if it detects that either of the processes has exited.
# Otherwise it loops forever, waking up every 60 seconds
while sleep 60; do
  ps aux |grep v2ray |grep -q -v grep
  PROCESS_1_STATUS=$?
  ps aux |grep mtg |grep -q -v grep
  PROCESS_2_STATUS=$?
  ps aux |grep haproxy |grep -q -v grep
  PROCESS_3_STATUS=$?
  ps aux |grep ssserver |grep -q -v grep
  PROCESS_4_STATUS=$?
  # If the greps above find anything, they exit with 0 status
  # If they are not both 0, then something is wrong
  if [ $PROCESS_1_STATUS -ne 0 -o $PROCESS_2_STATUS -ne 0 -o $PROCESS_3_STATUS -ne 0 -o $PROCESS_4_STATUS -ne 0 ]; then
    echo "One of the processes has already exited."
    #exit 1
  fi
done
