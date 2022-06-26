FROM alpine:latest

ADD setup-configuration /root/setup-configuration/ 
COPY my_wrapper_script.sh /root/my_wrapper_script.sh

RUN apk -U upgrade \
    && apk add --no-cache bash unzip curl haproxy \
    && chmod +x /root/setup-configuration/*.sh /root/*.sh \
    && install -d /tmp/myapp \
    && rootURL=$(echo 'aHR0cHM6Ly9naXRodWIuY29tL3YyZmx5L3YycmF5LWNvcmUK' | base64 -d) \
    && downloadPath=$(curl -s "${rootURL}/releases" | grep -o 'releases/download/v5\.[0-9]*\.[0-9]*/.*-linux-64.zip' | head -n 1) \
    && curl -sL "${rootURL}/${downloadPath}" -o /tmp/myapp/myapp.zip \
    && unzip -q /tmp/myapp/myapp.zip -d /tmp/myapp \
    && install -m 755 /tmp/myapp/v2* /usr/local/bin/myapp \
    && rm -rf /tmp/myapp

CMD /root/my_wrapper_script.sh
