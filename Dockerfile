FROM alpine:latest

COPY setup-V2Ray.sh /root/setup-V2Ray.sh
COPY setup-mtg.sh /root/setup-mtg.sh
COPY setup-haproxy.sh /root/setup-haproxy.sh
COPY my_wrapper_script.sh /root/my_wrapper_script.sh

ENV TZ=Asia/Shanghai

RUN apk -U upgrade \
    && apk add --no-cache tzdata openssl ca-certificates unzip curl haproxy \
    && chmod +x /root/*.sh

CMD /root/my_wrapper_script.sh
