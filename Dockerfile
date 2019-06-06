FROM alpine:3.9.4 as builder

ADD src /build

WORKDIR /build

RUN \
  apk add \
    gcc \
    libconfig-dev \
    make \
    musl-dev \
    pcre-dev \
    perl && \
  make sslh-select && \
  strip sslh-select


FROM alpine:3.9.4

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/tnwhitwell/sslh-hub" \
      org.label-schema.docker.cmd="docker run -e SSH_HOST=host -e HTTPS_HOST=host -e OPENVPN_HOST=host -e SHADOWSOCKS_HOST=host -p 443:8443 tnwhitwell/sslh-hub" \
      org.label-schema.docker.params="SSH_HOST=host running sshd,SSH_PORT=port to connect to SSH_HOST on. Default: 22,HTTPS_HOST=host running HTTPS server, HTTPS_PORT=port to connect to HTTPS_HOST on. Default: 443,OPENVPN_HOST=host running openvpn,OPENVPN_PORT=port to connect to OPENVPN_HOST on. Default: 1194,SHADOWSOCKS_HOST=host running shadowsocks,SHADOWSOCKS_PORT=port to connect to SHADOWSOCKS_HOST on. Default:8388" \
      org.label-schema.schema-version="1.0" \
      maintainer="Tom Whitwell <tom@whi.tw>"

RUN apk --no-cache add libconfig pcre && adduser -D -g '' sslh

COPY --from=builder /build/sslh-select /sslh

COPY entry.sh /usr/local/bin/entry.sh

USER sslh

EXPOSE 8443

ENTRYPOINT ["/bin/sh", "/usr/local/bin/entry.sh"]
