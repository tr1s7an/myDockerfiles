FROM alpine:latest

ADD setup-configuration /root/setup-configuration/ 
COPY my_wrapper_script.sh /root/my_wrapper_script.sh

RUN apk -U upgrade \
    && apk add --no-cache bash unzip curl haproxy \
    && chmod +x /root/setup-configuration/*.sh /root/*.sh \
    && install -d /tmp/app \
    && curl -sL 'https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip' -o /tmp/app/app.zip \
    && unzip -q /tmp/app/app.zip -d /tmp/app \
    && install -m 755 /tmp/app/v2ray /usr/local/bin/app \
    && install -m 755 /tmp/app/v2ctl /usr/local/bin/app-helper \
    && rm -rf /tmp/app

CMD /root/my_wrapper_script.sh
