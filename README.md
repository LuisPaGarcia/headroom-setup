# Headroom Docker Setup

This folder manages the local Headroom Docker runtime.

## Start

The current container was started outside Compose, so take it over once:

```sh
docker stop headroom-default
docker rm headroom-default
make up
```

After that:

```sh
make restart
make logs
make ps
```

Headroom listens on `http://127.0.0.1:8787`.

## Configuration

Edit `.env` for Docker-machine settings:

- `HEADROOM_IMAGE` changes the image/tag.
- `HEADROOM_PORT` changes the host and container port.
- `HEADROOM_MODE` and `HEADROOM_BACKEND` change the proxy mode/backend.
- `HEADROOM_CACHE_DIR` changes where Hugging Face and other runtime caches live on the host.

Headroom app settings still live in:

```sh
~/.headroom/settings.json
```

That directory is mounted into the container at `/tmp/headroom-home/.headroom`.

## Disk Fix

The log error:

```text
No space left on device: '/tmp/headroom-home/.cache/huggingface'
```

happens when Hugging Face writes cache files into the container writable layer.
This setup mounts:

```text
${HEADROOM_CACHE_DIR}:/tmp/headroom-home/.cache
```

and sets:

```text
XDG_CACHE_HOME=/tmp/headroom-home/.cache
HF_HOME=/tmp/headroom-home/.cache/huggingface
```

So cache growth lands on the host instead of filling the container layer.

Docker itself also has reclaimable space. Check it with:

```sh
docker system df
```

Clean only when you are sure unused images/build cache are disposable:

```sh
docker builder prune
docker image prune
```
