FROM alpine:latest

ADD setup-configuration /root/setup-configuration/ 
COPY my_wrapper_script.sh /root/my_wrapper_script.sh

RUN apk -U upgrade \
    && apk add --no-cache bash unzip curl haproxy \
    && chmod +x /root/setup-configuration/*.sh /root/*.sh \
    && install -d /tmp/myapp \
    && downloadPath=$(curl -s 'https://github.com/v2fly/v2ray-core/releases' | grep -o '/v2fly/v2ray-core/releases/download/v5\.[0-9]*.[0-9]*/v2ray-linux-64.zip' | head -n 1) \
    && curl -sL "https://github.com/${downloadPath}" -o /tmp/myapp/myapp.zip \
    && unzip -q /tmp/myapp/myapp.zip -d /tmp/myapp \
    && install -m 755 /tmp/myapp/v2ray /usr/local/bin/myapp \
    && rm -rf /tmp/myapp

CMD /root/my_wrapper_script.sh
