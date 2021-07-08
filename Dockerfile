FROM alpine:latest

COPY setup-v2ray.sh /root/setup-v2ray.sh
COPY setup-mtg.sh /root/setup-mtg.sh
COPY setup-haproxy.sh /root/setup-haproxy.sh
COPY setup-sshd.sh /root/setup-sshd.sh
COPY my_wrapper_script.sh /root/my_wrapper_script.sh

RUN apk -U upgrade \
    && apk add --no-cache tzdata openssl ca-certificates unzip curl haproxy openssh \
    && chmod +x /root/*.sh

CMD /root/my_wrapper_script.sh
