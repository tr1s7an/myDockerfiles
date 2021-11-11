FROM alpine:latest

ADD setup-configuration /root/setup-configuration/ 
COPY my_wrapper_script.sh /root/my_wrapper_script.sh

RUN apk -U upgrade \
    && apk add --no-cache bash unzip curl haproxy \
    && chmod +x /root/setup-configuration/*.sh /root/*.sh \
    && mkdir /tmp/v2ray \
    && curl -sL 'https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip' -o /tmp/v2ray/v2ray.zip \
    && unzip -q /tmp/v2ray/v2ray.zip -d /tmp/v2ray \
    && install -m 755 /tmp/v2ray/v2ray /usr/local/bin/v2ray \
    && install -m 755 /tmp/v2ray/v2ctl /usr/local/bin/v2ctl \
    && rm -rf /tmp/v2ray

CMD /root/my_wrapper_script.sh
