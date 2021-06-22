FROM alpine:latest

ADD configure.sh /configure.sh

ENV TZ=Asia/Shanghai

RUN apk add --no-cache -U ca-certificates unzip wget \
    && chmod +x /configure.sh

CMD /configure.sh