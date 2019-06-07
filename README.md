# docker-sslh

[![Docker Pulls](https://img.shields.io/docker/pulls/tnwhitwell/sslh.svg)](https://hub.docker.com/r/tnwhitwell/sslh/)
[![Image Layers](https://images.microbadger.com/badges/image/tnwhitwell/sslh.svg)](https://microbadger.com/images/tnwhitwell/sslh "Get your own image badge on microbadger.com")
[![Latest built Commit](https://images.microbadger.com/badges/commit/tnwhitwell/sslh.svg)](https://microbadger.com/images/tnwhitwell/sslh "Get your own commit badge on microbadger.com")
[![Dependabot Status](https://api.dependabot.com/badges/status?host=github&repo=tnwhitwell/docker-sslh)](https://dependabot.com)

Docker alpine image containing [sslh](https://github.com/yrutschle/sslh), configurable with environment variables.

## Usage

By default, no multiplexing options are enabled:

> Start and expose port 443 with no configurations

```bash
docker run -d -p 443:8443 --name sslh tnwhitwell/sslh
```

To configure a backend, set at least the `*_HOST` env var:

> Start and configure SSH and HTTPS with default ports

```bash
docker run -e SSH_HOST=host -e HTTPS_HOST=somehost.internal -p 443:8443 tnwhitwell/sslh
```

If the service is not listening on the default port, it can be overridden with the `*_PORT` env var:

> Start and configure SSH and HTTPS with custom ports

```bash
docker run -e SSH_HOST=host -e SSH_PORT=2222 -e HTTPS_HOST=somehost.internal -e HTTPS_PORT=8443 -p 443:8443 tnwhitwell/sslh
```

### Available Environment Variables

Naming should be self explanatory, defaults are indicated.

If a `*_HOST` environment variable is omitted, it will not be configured.

```bash
HTTPS_HOST=
HTTPS_PORT=443

OPENVPN_HOST=
OPENVPN_PORT=1194

SHADOWSOCKS_HOST=
SHADOWSOCKS_PORT=8388

SSH_HOST=
SSH_PORT=22

TRANSPARENT=false # This is currently WIP and doesn't seem to work properly. This could be a me problem, though, and could do with some investigation.
```

## docker-compose

This can also be run with docker-compose:

```yaml
---
version: '3'
services:
  web:
    image: nginx:latest
  sslh:
    image: tnwhitwell/sslh:latest
    ports:
      - 443:8443
    environment:
      HTTPS_HOST: web
      HTTPS_PORT: 443
      SSH_HOST: 172.17.0.1 # Point to the Docker Host's IP
      SSH_PORT: 22
    depends_on:
      - web
```

----

Thanks to [@shaddysignal](https://github.com/shaddysignal)'s [sslh-hub](https://github.com/shaddysignal/sslh-hub) for inspiration.
