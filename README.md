# A small but useful Docker image

## Description

    HAProxy(:8080)
      |-- V2Ray trojan over websocket      (unix:/var/run/trojanws.sock, routed by MAINPATH)
      |-- V2Ray vmess over websocket       (unix:/var/run/vmessws.sock, routed by VMESSPATH)
      |-- V2Ray trojan over grpc           (unix:/var/run/trojangrpc.sock, routed by HTTP_2.0)
      |-- mtg                              (127.0.0.1:8082, routed by fake tls SNI)
      |-- shadowsocks-rust-server          (0.0.0.0:8083, by default)
      |-- others                           (*:443, routed by SNI)

    WIREGUARD(:44444)

    # The trojan protocol must be used in a trusted channel, such as a TLS tunnel
    # Map port 8083 alone for UDP support since HAProxy doesn't support UDP load balancing
    # WIREGUARD is optional and it will start with **-e ENABLE_WG=yes --cap-add net_admin**
    # Also add **--sysctl net.ipv6.conf.all.disable_ipv6=0 --sysctl net.ipv6.conf.all.forwarding=1** for WIREGUARD IPv6 support

## Environment Variables (auto generation enabled)

- for V2Ray:

  - UUID
  - MAINPATH
  - VMESSPATH

- for mtg:

  - mtgsecret

- for shadowsocks-rust-server:

  - password

- for HAProxy:
  
  - mtgsni

- for WIREGUARD:

  - serverprikey
  - clientprikey
