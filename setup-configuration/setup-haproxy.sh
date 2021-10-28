#!/bin/bash

install -d /usr/local/etc/haproxy
cat << EOF > /usr/local/etc/haproxy/haproxy.cfg
global
    maxconn     128 
    log         127.0.0.1 local0

defaults
    log global
    mode tcp
    timeout connect 1m
    timeout client 1m
    timeout server 1m

frontend main
    mode tcp
    bind :8080
    tcp-request inspect-delay 5s
    tcp-request content accept if { req.ssl_hello_type 1 }
    
    acl mtgsni req.ssl_sni -i ${mtgsni}
    acl smtpsni req.ssl_sni -i smtp.gmail.com
    acl imapsni req.ssl_sni -i imap.gmail.com
    
    use_backend mtg if mtgsni 
    use_backend smtp if smtpsni
    use_backend imap if imapsni
    use_backend vmess if HTTP_1.1
    use_backend trojan if HTTP_2.0
    default_backend ss 

backend vmess
    mode http 
    server vmess ${VMESS_DOMAIN_SOCKET_FILE} 

backend trojan 
    mode http 
    server trojan ${TROJAN_DOMAIN_SOCKET_FILE} proto h2

backend mtg
    mode tcp
    server mtg 127.0.0.1:8082

backend smtp
    mode tcp
    server smtp 142.250.141.108:465

backend imap
    mode tcp
    server imap 142.250.141.108:993

backend ss
    mode tcp
    server ss 127.0.0.1:8083
EOF
