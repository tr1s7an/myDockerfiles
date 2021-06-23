FROM alpine:latest

ADD configure.sh /configure.sh

ENV TZ=Asia/Shanghai

RUN apk -U upgrade \
    && apk add --no-cache tzdata openssl ca-certificates unzip wget \
    && chmod +x /configure.sh

CMD /configure.sh
