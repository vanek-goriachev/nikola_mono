build-backend:
	docker-compose -f ./backend/docker-compose.yml --env-file ./\.env build
build-frontend:
	docker-compose -f ./frontend/docker-compose.yml --env-file ./\.env build
build:
	$(MAKE) build-backend
	$(MAKE) build-frontend

up-backend:
	docker-compose -f ./backend/docker-compose.yml --env-file ./\.env up -d
up-frontend:
	docker-compose -f ./frontend/docker-compose.yml --env-file ./\.env up -d
up:
	$(MAKE) up-backend
	$(MAKE) up-frontend

down-backend:
	docker-compose -f ./backend/docker-compose.yml down
down-frontend:
	docker-compose -f ./frontend/docker-compose.yml down
down:
	$(MAKE) down-backend
	$(MAKE) down-frontend

logs:
	docker-compose logs

run:
	$(MAKE) build
	$(MAKE) up

load-backend-fixtures:
	docker

.PHONY: build-backend build-frontend build up-backend up-frontend up down-backend down-frontend down logs run