#!/bin/bash

install -d /usr/local/etc/haproxy
cat << EOF > /usr/local/etc/haproxy/haproxy.cfg
global
    maxconn     128
    log         127.0.0.1 local0

defaults
    log global
    timeout connect 1m
    timeout client 1m
    timeout server 1m

frontend main
    mode http
    bind :${PORT} alpn h2,http/1.1

    acl trojanwspath path_beg /${TROJANWSPATH}
    acl vmesswspath path_beg /${VMESSWSPATH}
    acl trojangrpcpath path_beg /${TROJANGRPCPATH}

    capture request header Host len 64
    use_backend trojanws if trojanwspath
    use_backend vmessws if vmesswspath
    use_backend trojangrpc if trojangrpcpath
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
    http-response replace-header Location https://${FALLBACK}(.*) https://%[capture.req.hdr(0)]\1
    http-response set-header Strict-Transport-Security max-age=63072000
    http-request set-header Host ${FALLBACK}:443
    http-request set-header Referer https://${FALLBACK}
    http-request set-header X-Forwarded-For 50.31.246.4
    http-request set-header X-Real-IP 50.31.246.4
    server web ${FALLBACK}:443 resolvers mydns resolve-prefer ipv4 ssl sni str(${FALLBACK}) alpn http/1.1 force-tlsv13 verify required verifyhost ${FALLBACK} ca-file /etc/ssl/cert.pem

resolvers mydns
  nameserver cloudflare 1.1.1.1:53
EOF
