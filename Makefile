build-backend:
	docker-compose -f ./backend/docker-compose.yml --env-file ./\.env build
build-frontend:
	docker-compose -f ./frontend/docker-compose.yml --env-file ./\.env build
build-redis:
	docker-compose -f ./redis.yml --env-file ./\.env build
build-postgres:
	docker-compose -f ./postgres.yml --env-file ./\.env build
build:
	$(MAKE) build-backend
	$(MAKE) build-frontend

up-backend:
	docker-compose -f ./backend/docker-compose.yml --env-file ./\.env up -d
up-frontend:
	docker-compose -f ./frontend/docker-compose.yml --env-file ./\.env up -d
up-redis:
	docker-compose -f ./redis.yml --env-file ./\.env up -d
up-postgres:
	docker-compose -f ./postgres.yml --env-file ./\.env up -d
up:
	$(MAKE) up-backend
	$(MAKE) up-frontend

down-backend:
	docker-compose -f ./backend/docker-compose.yml --env-file ./\.env down
down-frontend:
	docker-compose -f ./frontend/docker-compose.yml --env-file ./\.env down
down-redis:
	docker-compose -f ./redis.yml --env-file ./\.env down
down-postgres:
	docker-compose -f ./postgres.yml --env-file ./\.env down
down:
	$(MAKE) down-backend
	$(MAKE) down-frontend

logs-backend:
	docker-compose -f ./backend/docker-compose.yml --env-file ./\.env logs
logs-frontend:
	docker-compose -f ./frontend/docker-compose.yml --env-file ./\.env logs

run:
	$(MAKE) build
	$(MAKE) up

run-everything:
    $(MAKE) build-postgres
    $(MAKE) build-redis
    $(MAKE) up-postgres
    $(MAKE) up-redis
    $(MAKE) run

load-backend-fixtures:
	docker

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
