.DEFAULT_GOAL := build
.PHONY: build

setup:
	cp -n .env.dist .env
	cp -n docker-compose.local.yml.dist docker-compose.local.yml

build:
	docker-compose build app

run:
	docker-compose run --rm app

stop:
	docker-compose stop

destroy:
	docker-compose down -v --remove-orphans --rmi local