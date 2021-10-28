#/bin/bash

ping -c 1 -6 www.google.com
if [ ${?} -eq 2 ]; then
cat << EOF > /etc/wireguard/${interface_name}.conf
[Interface]
  PrivateKey = ${serverprikey} 
  Address    = 10.10.10.1/24
  PostUp     = iptables -A FORWARD -i ${interface_name} -j ACCEPT; iptables -A FORWARD -o ${interface_name} -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE;
  PostDown   = iptables -D FORWARD -i ${interface_name} -j ACCEPT; iptables -D FORWARD -o ${interface_name} -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE;
  ListenPort = 44444
  DNS        = 1.0.0.1
  MTU        = 1420

[Peer]
  PublicKey  = ${clientpubkey}
  AllowedIPs = 10.10.10.2/32
EOF
else
cat << EOF > /etc/wireguard/${interface_name}.conf
[Interface]
  PrivateKey = ${serverprikey} 
  Address    = 10.10.10.1/24,fdff::1/64
  PostUp     = iptables -A FORWARD -i ${interface_name} -j ACCEPT; iptables -A FORWARD -o ${interface_name} -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE; ip6tables -A FORWARD -i ${interface_name} -j ACCEPT; ip6tables -A FORWARD -o ${interface_name} -j ACCEPT; ip6tables -t nat -A POSTROUTING -o eth0 -j MASQUERADE;
  PostDown   = iptables -D FORWARD -i ${interface_name} -j ACCEPT; iptables -D FORWARD -o ${interface_name} -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE; ip6tables -D FORWARD -i ${interface_name} -j ACCEPT; ip6tables -D FORWARD -o ${interface_name} -j ACCEPT; ip6tables -t nat -D POSTROUTING -o eth0 -j MASQUERADE;
  ListenPort = 44444
  DNS        = 1.0.0.1,2606:4700:4700::1001
  MTU        = 1420

[Peer]
  PublicKey  = ${clientpubkey}
  AllowedIPs = 10.10.10.2/32,fdff::2/128
EOF
fi

