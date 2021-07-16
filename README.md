## Description

    haproxy(:8080)
      |-- v2ray      (127.0.0.1:8081, by default)
      |-- mtg        (127.0.0.1:8082, routed by fake tls SNI)
      |-- sshd       (127.0.0.1:22, routed by req.payload(0,7)==5353482d322e30)
      |-- others     (*:443, routed by SNI)


## Required env variables

- for v2ray:

  - UUID
  - WSPATH

- for mtg:

    - mtgsecret

- for sshd:

    - password

- for haproxy:
  
    - mtgsni
