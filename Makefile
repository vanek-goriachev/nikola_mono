
ENV_FILE := .env

# External services
run-redis:
	docker-compose -f ./redis.yml --env-file $(ENV_FILE) up --build -d
run-postgres:
	docker-compose -f ./postgres.yml --env-file $(ENV_FILE) up --build -d
create-network:
	docker network create nikola-docker-network

# Backend container commands
build-backend:
	docker-compose -f ./backend/docker-compose.yml --env-file $(ENV_FILE) build
up-backend:
	docker-compose -f ./backend/docker-compose.yml --env-file $(ENV_FILE) up -d
run-backend:
	$(MAKE) build-backend
	$(MAKE) up-backend
down-backend:
	docker-compose -f ./backend/docker-compose.yml --env-file $(ENV_FILE) down
logs-backend:
	docker logs backend

# Backend actions
backend-migrate-db:
	docker exec -it backend python manage.py makemigrations
	docker exec -it backend python manage.py migrate
backend-create-superuser:
	docker exec -it backend python manage.py createsuperuser
backend-fill-db:
	docker exec -it backend python manage.py loaddata fixtures.json
backend-bash:
	docker exec -it backend bash

# Frontend container commands
rm-cache-frontend:
	docker stop frontend
	docker rm frontend
build-frontend:
	docker-compose -f ./frontend/docker-compose.yml --env-file $(ENV_FILE) build
up-frontend:
	docker-compose -f ./frontend/docker-compose.yml --env-file $(ENV_FILE) up -d
run-frontend:
	$(MAKE) build-frontend
	$(MAKE) up-frontend
down-frontend:
	docker-compose -f ./frontend/docker-compose.yml --env-file $(ENV_FILE) down
logs-frontend:
	docker logs frontend

# Frontend actions
frontend-bash:
	docker exec -it frontend bash

# Nginx (with brotli) container commands
build-nginx_with_brotli:
	docker build -f ./nginx_with_brotli/Dockerfile ./nginx_with_brotli -t nikola/nginx_with_brotli
