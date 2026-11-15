FROM debian:trixie-slim

LABEL com.resilio.version="3.1.3"
LABEL org.opencontainers.image.authors="Resilio Inc. <support@resilio.com>"

ARG RSL_URL=https://download-cdn.resilio.com/3.1.3.1080/linux/x64/0/resilio-sync_x64.tar.gz
ARG RSL_SHA256=4c4ebf8cdf992682843cd13baee307cc569615dfe1e4ba3c5061734bd7117e9b

ENV TZ=Australia/Sydney

RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates curl tzdata \
 && ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime \
 && echo "$TZ" > /etc/timezone \
 && curl -fsSL -o /tmp/sync.tgz "$RSL_URL" \
 && echo "${RSL_SHA256}  /tmp/sync.tgz" | sha256sum -c - \
 && tar -xf /tmp/sync.tgz -C /usr/bin rslsync \
 && rm -f /tmp/sync.tgz \
 && apt-get purge -y --auto-remove curl \
 && rm -rf /var/lib/apt/lists/*

COPY sync.conf.default /etc/
COPY run_sync /usr/bin/

EXPOSE 8888
EXPOSE 46098/tcp 46098/udp

VOLUME /mnt/sync

ENTRYPOINT ["run_sync"]
CMD ["--config", "/mnt/sync/sync.conf"]
