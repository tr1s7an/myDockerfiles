#/bin/bash

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
