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
    bind :${PORT}
    tcp-request inspect-delay 5s
    tcp-request content accept if { req.ssl_hello_type 1 }

    acl mainpath path_beg /${MAINPATH}
    acl vmesspath path_beg /${VMESSPATH}
    acl trojanpath path /${TROJANPATH}/Tun
    acl mtgsni req.ssl_sni -i ${mtgsni}
    acl smtpsni req.ssl_sni -i smtp.gmail.com
    acl imapsni req.ssl_sni -i imap.gmail.com
    
    use_backend mtg if mtgsni 
    use_backend smtp if smtpsni
    use_backend imap if imapsni
    use_backend ss if !HTTP
    use_backend main if mainpath
    use_backend vmess if vmesspath
    use_backend trojan if trojanpath
    default_backend web 

backend main 
    mode http 
    server main ${MAIN_DOMAIN_SOCKET_FILE}

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

backend web
    mode http
    http-request set-header Host ${FALLBACK}:443
    server web ${FALLBACK}:443 resolvers mydns ssl sni str(${FALLBACK}) alpn http/1.1 force-tlsv13 verify required verifyhost ${FALLBACK} ca-file /etc/ssl/certs/ca-certificates.crt

resolvers mydns
  nameserver cloudflare 1.1.1.1:53
EOF
