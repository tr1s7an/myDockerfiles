#!/bin/sh

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
    
    use_backend mtg if { req.ssl_hello_type 1 }
    default_backend v2ray

backend v2ray
    mode tcp
    option tcp-check
    server node1 127.0.0.1:8081

backend mtg 
    mode tcp
    option tcp-check
    server node2 127.0.0.1:8082

EOF

/usr/sbin/haproxy -f /usr/local/etc/haproxy/haproxy.cfg
