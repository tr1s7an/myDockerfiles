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

frontend webfrontend
    mode http
    bind 127.0.0.1:32765
    default_backend web 

frontend main
    mode http
    bind :${PORT}

    acl trojanwspath path_beg /${TROJANWSPATH}
    acl vmesswspath path_beg /${VMESSWSPATH}

    use_backend trojanws if trojanwspath
    use_backend vmessws if vmesswspath
    use_backend trojangrpc if HTTP_2.0
    default_backend web 

backend trojanws 
    mode http 
    server trojanws ${TROJANWS_DOMAIN_SOCKET_FILE}

backend vmessws
    mode http 
    server vmessws ${VMESSWS_DOMAIN_SOCKET_FILE} 

backend trojangrpc 
    mode http 
    server trojangrpc ${TROJANGRPC_DOMAIN_SOCKET_FILE} proto h2

backend web
    mode http
    http-request set-header Host ${FALLBACK}:443
    server web ${FALLBACK}:443 resolvers mydns resolve-prefer ipv4 ssl sni str(${FALLBACK}) alpn http/1.1 force-tlsv13 verify required verifyhost ${FALLBACK} ca-file /etc/ssl/certs/ca-certificates.crt

resolvers mydns
  nameserver cloudflare 1.1.1.1:53
EOF
