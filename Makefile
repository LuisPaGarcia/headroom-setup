# docker stop headroom-default, docker rm headroom-default, then make up

include .env

.PHONY: up down restart logs ps cache-dir

cache-dir:
	mkdir -p "$(HEADROOM_CACHE_DIR)"

up: cache-dir
	docker compose up -d

down:
	docker compose down

restart: cache-dir
	docker compose up -d --force-recreate

logs:
	docker compose logs -f --tail=200

ps:
	docker compose ps
