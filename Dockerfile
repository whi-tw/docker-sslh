FROM alpine:3.10.3 as builder

ADD src /build

WORKDIR /build

RUN \
  apk add \
    gcc \
    libconfig-dev \
    make \
    musl-dev \
    pcre-dev \
    libcap-dev \
    perl && \
  make sslh-select USELIBCAP=1 && \
  strip sslh-select


FROM alpine:3.10.3

ARG VCS_REF
ARG BUILD_DATE

LABEL org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.vcs-url="https://github.com/tnwhitwell/docker-sslh" \
      org.label-schema.docker.cmd="docker run [--cap-add NET_ADMIN] -e SSH_HOST=host -e HTTPS_HOST=host -e OPENVPN_HOST=host -e SHADOWSOCKS_HOST=host -p 443:8443 tnwhitwell/sslh" \
      org.label-schema.docker.params="SSH_HOST=host running sshd,SSH_PORT=port to connect to SSH_HOST on. Default: 22,HTTPS_HOST=host running HTTPS server, HTTPS_PORT=port to connect to HTTPS_HOST on. Default: 443,OPENVPN_HOST=host running openvpn,OPENVPN_PORT=port to connect to OPENVPN_HOST on. Default: 1194,SHADOWSOCKS_HOST=host running shadowsocks,SHADOWSOCKS_PORT=port to connect to SHADOWSOCKS_HOST on. Default:8388,TRANSPARENT=run sslh as a transparent proxy (requires --cap-add NET_ADMIN)" \
      org.label-schema.schema-version="1.0" \
      maintainer="Tom Whitwell <tom@whi.tw>"

COPY --from=builder /build/sslh-select /sslh

RUN apk --no-cache add libconfig libcap pcre && adduser -D -g '' sslh

COPY entry.sh /usr/local/bin/entry.sh

EXPOSE 8443

ENTRYPOINT ["/bin/sh", "/usr/local/bin/entry.sh"]
