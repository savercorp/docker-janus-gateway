# docker-janus-gateway

Docker image for [Janus Gateway](https://github.com/meetecho/janus-gateway).  
Maintained by [Saver Corporation](https://github.com/savercorp).

## Supported tags

- 0.10.7

## How to use this image

### docker command

```bash
$ docker run -d -p "8188:8188" --name=janus saverops/janus-gateway
```

### docker-compose

```yaml
version: "3"

services:
  janus:
    image: saverops/janus-gateway
    ports:
      - 8188:8188
```

```bash
$ docker-compose up -d
```

## Custom config

### docker command

```bash
$ docker run -d \
  -p "8188:8188" \
  -v "$(pwd)/conf/janus.jcfg:/opt/janus/etc/janus/janus.jcfg" \
  -v "$(pwd)/conf/janus.plugin.videoroom.jcfg:/opt/janus/etc/janus/janus.plugin.videoroom.jcfg" \
  --name=janus \
  saverops/janus-gateway
```

### docker-compose

```yaml
version: "3"

services:
  janus:
    image: saverops/janus-gateway
    ports:
      - 8188:8188
    volumes:
      - ./conf/janus.jcfg:/opt/janus/etc/janus/janus.jcfg
      - ./conf/janus.plugin.videoroom.jcfg:/opt/janus/etc/janus/janus.plugin.videoroom.jcfg
```

```bash
$ docker-compose up -d
```

## Contributing

Please read through our [contributing guidelines](https://github.com/savercorp/docker-janus-gateway/blob/main/.github/CONTRIBUTING.md).
