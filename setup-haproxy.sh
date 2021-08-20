#!/bin/sh

mtgsni=$(cat ~/mtgsni)
install -d /usr/local/etc/haproxy
cat << EOF > /usr/local/etc/haproxy/haproxy.cfg
global
    maxconn     512
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
    acl dnssni req.ssl_sni -i dns.alidns.com
    acl smtpsni req.ssl_sni -i smtp.gmail.com
    acl imapsni req.ssl_sni -i imap.gmail.com
    
    use_backend mtg if mtgsni 
    use_backend ali if dnssni
    use_backend smtp if smtpsni
    use_backend imap if imapsni
    use_backend ss if !HTTP
    default_backend v2ray

backend v2ray
    mode tcp
    option tcp-check
    server node1 127.0.0.1:8081

backend mtg
    mode tcp
    option tcp-check
    server node2 127.0.0.1:8082

backend ali
    mode tcp
    option tcp-check
    server node3 223.5.5.5:443

backend smtp
    mode tcp
    option tcp-check
    server node4 142.250.141.108:465

backend imap
    mode tcp
    option tcp-check
    server node5 142.250.141.108:993

backend ss
    mode tcp
    option tcp-check
    server node6 127.0.0.1:8083

EOF
