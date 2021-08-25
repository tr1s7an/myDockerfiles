## Description

    haproxy(:8080)
      |-- v2ray               (127.0.0.1:8081, by default)
      |-- mtg                 (127.0.0.1:8082, routed by fake tls SNI)
      |-- shadowsocks-rust    (127.0.0.1:8083, routed by !HTTP)
      |-- others              (*:443, routed by SNI)


## Required Env Variables (auto generation enabled)

- for v2ray:

  - UUID
  - WSPATH

- for mtg:

    - mtgsecret

- for shadowsocks-rust-server:

    - password

- for haproxy:
  
    - mtgsni
