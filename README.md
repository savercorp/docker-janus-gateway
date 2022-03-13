# janus-container

Janus Gateway Docker image.

## Getting Started

80 port (web server) is only for trial not for production.

### Docker

```bash
$ docker pull registry.gitlab.saver.jp/saver/container/janus-gateway
$ docker run -d -p "8188:8188" -p "80:80" --name=sfu registry.gitlab.saver.jp/saver/container/janus-gateway
```

### docker-compose

```yaml
version: "3"

services:
  sfu:
    image: registry.gitlab.saver.jp/saver/container/janus-gateway
    ports:
      - 8188:8188
      - 80:80
```

```bash
$ docker-compose up -d
```

## Custom config

If you want your own configuration.  
Mount config like this.

### Docker

```bash
$ docker pull registry.gitlab.saver.jp/saver/container/janus-gateway
$ docker run -d \
  -p "8188:8188" \
  -v "$(pwd)/conf/janus.jcfg:/opt/janus/etc/janus/janus.jcfg" \
  -v "$(pwd)/conf/janus.plugin.videoroom.jcfg:/opt/janus/etc/janus/janus.plugin.videoroom.jcfg" \
  --name=sfu \
  registry.gitlab.saver.jp/saver/container/janus-gateway
```

### docker-compose

```yaml
version: "3"

services:
  sfu:
    image: registry.gitlab.saver.jp/saver/container/janus-gateway
    ports:
      - 8188:8188
    volumes:
      - ./conf/janus.jcfg:/opt/janus/etc/janus/janus.jcfg
      - ./conf/janus.plugin.videoroom.jcfg:/opt/janus/etc/janus/janus.plugin.videoroom.jcfg
```

```bash
$ docker-compose up -d
```
