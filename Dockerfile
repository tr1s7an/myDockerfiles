FROM alpine:latest

COPY setup-v2ray.sh /root/setup-v2ray.sh
COPY setup-mtg.sh /root/setup-mtg.sh
COPY setup-haproxy.sh /root/setup-haproxy.sh
COPY setup-sshd.sh /root/setup-sshd.sh
COPY my_wrapper_script.sh /root/my_wrapper_script.sh

RUN apk -U upgrade \
    && apk add --no-cache tzdata openssl ca-certificates unzip curl haproxy openssh \
    && chmod +x /root/*.sh \
    && mkdir /tmp/v2ray \
    && curl -sL https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip -o /tmp/v2ray/v2ray.zip \
    && unzip /tmp/v2ray/v2ray.zip -d /tmp/v2ray \
    && install -m 755 /tmp/v2ray/v2ray /usr/local/bin/v2ray \
    && install -m 755 /tmp/v2ray/v2ctl /usr/local/bin/v2ctl \
    && rm -rf /tmp/v2ray \
    && mkdir /tmp/mtg \
    && export mtg_version=$(curl -s https://github.com/9seconds/mtg/releases/latest | grep -o '\/v[0-9].*[0-9]' | grep -o '[0-9].*[0-9]') \
    && export url="https://github.com/9seconds/mtg/releases/download/v${mtg_version}/mtg-${mtg_version}-linux-amd64.tar.gz" \
    && curl -sL "${url}" -o /tmp/mtg/mtg.tar.gz \
    && tar -C /tmp/mtg -xf /tmp/mtg/mtg.tar.gz \
    && install -m 755 /tmp/mtg/mtg-${mtg_version}-linux-amd64/mtg /usr/local/bin/mtg \
    && rm -rf /tmp/mtg

CMD /root/my_wrapper_script.sh
