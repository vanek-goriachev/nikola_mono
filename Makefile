create-network:
	docker network create nikola-docker-network


build-nginx:
	docker-compose -f ./nginx/docker-compose.yml --env-file ./\.env build
build-backend:
	docker-compose -f ./backend/docker-compose.yml --env-file ./\.env build
build-frontend:
	docker-compose -f ./frontend/docker-compose.yml --env-file ./\.env build
build-redis:
	docker-compose -f ./redis.yml --env-file ./\.env build
build-postgres:
	docker-compose -f ./postgres.yml --env-file ./\.env build
build:
	$(MAKE) build-nginx
	$(MAKE) build-backend
	$(MAKE) build-frontend

up-nginx:
	docker-compose -f ./nginx/docker-compose.yml --env-file ./\.env up -d
up-backend:
	docker-compose -f ./backend/docker-compose.yml --env-file ./\.env up -d
up-frontend:
	docker-compose -f ./frontend/docker-compose.yml --env-file ./\.env up -d
up-redis:
	docker-compose -f ./redis.yml --env-file ./\.env up -d
up-postgres:
	docker-compose -f ./postgres.yml --env-file ./\.env up -d
up:
	$(MAKE) up-nginx
	$(MAKE) up-backend
	$(MAKE) up-frontend

down-nginx:
	docker-compose -f ./nginx/docker-compose.yml --env-file ./\.env down
down-backend:
	docker-compose -f ./backend/docker-compose.yml --env-file ./\.env down
down-frontend:
	docker-compose -f ./frontend/docker-compose.yml --env-file ./\.env down
down-redis:
	docker-compose -f ./redis.yml --env-file ./\.env down
down-postgres:
	docker-compose -f ./postgres.yml --env-file ./\.env down
down:
	$(MAKE) down-nginx
	$(MAKE) down-backend
	$(MAKE) down-frontend

logs-nginx:
	docker-compose -f ./nginx/docker-compose.yml --env-file ./\.env logs
logs-backend:
	docker-compose -f ./backend/docker-compose.yml --env-file ./\.env logs
logs-frontend:
	docker-compose -f ./frontend/docker-compose.yml --env-file ./\.env logs

run:
	$(MAKE) build-backend
	$(MAKE) up-backend
	$(MAKE) build-frontend
	$(MAKE) up-frontend

run-everything:
#	$(MAKE) build-postgres
	$(MAKE) build-redis
#	$(MAKE) up-postgres
	$(MAKE) up-redis
	$(MAKE) run

.PHONY:
	build-backend
	build-frontend
	build-redis
	build-postgres
	build

	up-backend
	up-frontend
	up-redis
	up-postgres
	up

	down-backend
	down-frontend
	down-redis
	down-postgres
	down

	logs-backend
	logs-frontend

	run
	run-everything
