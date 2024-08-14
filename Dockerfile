# Build stage
FROM --platform=linux/amd64 alpine:latest AS builder

RUN apk add --no-cache --update \
    autoconf \
    automake \
    g++ \
    gcc \
    git \
    libtool \
    linux-headers \
    make \
    openssl-dev \
    patch \
    sed

WORKDIR /build

RUN git clone --depth 1 --recursive https://github.com/RIPE-NCC/ripe-atlas-software-probe.git . && \
    autoreconf -iv && \
    ./configure --prefix=/probe --disable-chown --disable-setcap-install --disable-systemd && \
    make install && \
    strip /probe/bin/* /probe/libexec/ripe-atlas/measurement/* || true

# Final stage
FROM --platform=linux/amd64 alpine:latest

RUN apk add --no-cache --update \
    libcap \
    net-tools \
    openssh \
    tini && \
    adduser -D -H -s /sbin/nologin ripe-atlas && \
    rm -rf /var/cache/apk/*

COPY --from=builder /probe /probe

RUN setcap cap_net_raw=ep /probe/libexec/ripe-atlas/measurement/busybox && \
    chown -R ripe-atlas:ripe-atlas /probe

USER ripe-atlas

WORKDIR /probe

VOLUME ["/probe/etc/ripe-atlas", "/probe/var/run/ripe-atlas/status"]

ENTRYPOINT ["/sbin/tini", "--"]

CMD [ ! -f /probe/etc/ripe-atlas/config.txt ] && echo "RXTXRPT=yes" > /probe/etc/ripe-atlas/config.txt ; \
    [ ! -f /probe/etc/ripe-atlas/mode ] && echo "prod" > /probe/etc/ripe-atlas/mode ; \
    /probe/sbin/ripe-atlas
