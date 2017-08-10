# Resilio Sync
#
# VERSION               0.1
#

FROM florid/alpine-glibc
MAINTAINER Resilio Inc. <support@resilio.com>
LABEL com.resilio.version="2.5.7"

ENV TZ 'Australia/Sydney'
RUN apk update && \ 
apk upgrade && \ 
apk add --update tzdata && \ 
cp /usr/share/zoneinfo/${TZ} /etc/localtime && \ 
echo "${TZ}" > /etc/timezone && \
apk del tzdata && \
rm -rf /var/cache/apk/*

ADD https://download-cdn.resilio.com/2.5.7/linux-armhf/resilio-sync_armhf.tar.gz /tmp/sync.tgz
RUN tar -xf /tmp/sync.tgz -C /usr/bin rslsync && rm -f /tmp/sync.tgz

COPY sync.conf.default /etc/
COPY run_sync /usr/bin/

EXPOSE 8888
EXPOSE 46098/tcp 46098/udp

VOLUME /mnt/sync

ENTRYPOINT ["run_sync"]
CMD ["--config", "/mnt/sync/sync.conf"]
