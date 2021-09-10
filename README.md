# A small but useful Docker image

## Description

    HAProxy(:8080)
      |-- V2Ray                      (unix:/var/run/v2ray.sock, by default)
      |-- mtg                        (127.0.0.1:8082, routed by fake tls SNI)
      |-- shadowsocks-rust-server    (0.0.0.0:8083, routed by !HTTP)
      |-- others                     (*:443, routed by SNI)

    WIREGUARD(:44444)

    # Map port 8083 alone for UDP support since HAProxy doesn't support UDP load balancing
    # WIREGUARD is optional and it will start with **-e ENABLE_WG=yes --cap-add net_admin**

## Environment Variables (auto generation enabled)

- for V2Ray:

  - UUID
  - WSPATH

- for mtg:

  - mtgsecret

- for shadowsocks-rust-server:

  - password

- for HAProxy:
  
  - mtgsni

- for WIREGUARD:

  - serverprikey
  - clientprikey
