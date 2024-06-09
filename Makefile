# External services
run-redis:
	docker-compose -f ./redis.yml --env-file ./\.env up --build -d
run-postgres:
	docker-compose -f ./postgres.yml --env-file ./\.env up --build -d

# Backend container commands
build-backend:
	docker-compose -f ./backend/docker-compose.yml --env-file ./\.env build
up-backend:
	docker-compose -f ./backend/docker-compose.yml --env-file ./\.env up -d
run-backend:
	$(MAKE) build-backend
	$(MAKE) up-backend
down-backend:
	docker-compose -f ./backend/docker-compose.yml --env-file ./\.env down
logs-backend:
	docker logs backend

# Backend actions
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
	docker volume rm frontend_app_node_modules frontend_app_next
build-frontend:
	docker-compose -f ./frontend/docker-compose.yml --env-file ./\.env build
up-frontend:
	docker-compose -f ./frontend/docker-compose.yml --env-file ./\.env up -d
run-frontend:
	$(MAKE) build-frontend
	$(MAKE) up-frontend
down-frontend:
	docker-compose -f ./frontend/docker-compose.yml --env-file ./\.env down
logs-frontend:
	docker logs frontend

# Frontend actions
frontend-bash:
	docker exec -it frontend bash
