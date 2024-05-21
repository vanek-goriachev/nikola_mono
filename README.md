# LOCAL DEVELOPMENT

# Инструкция по локальному запуску проекта

1.  Стянуть проект с гитхаба
    
    ```bash
    git clone git@github.com:vanek-goriachev/nikola_mono.git
    cd nikola_mono
    git submodule init
    git submodule update # эта команда может занять много времени при стягивании фронта
    ```
    
2.  Заполнить файл .env
    
    ```bash
    # copy .env.example .env ## FOR WINDOWS
    cp .env.example .env
    ```
    
3. При локальной разработке если не переопределены в .env параметры для внешних сервисов (postgres, redis), то потребуется поднять локальные докер контейнеры с ними
    1. redis
        
        ```bash
        make run-redis
        ```
        
    2. postgres
        
        ```bash
        make run-postgres
        ```
        
4. Поднять backend
    
    ```bash
    make run-backend
    ```
    
    После этого следует зайти на [http://localhost:8002/backend/admin/](http://localhost:8002/backend/admin/login/?next=/backend/admin/) и убедиться что сервис поднят
    
5. Создать пользователя-админа в backend
    
    ```bash
    make backend-create-superuser
    ```
    
6. При необходимости налить базу данных бэкенда
    
    ```bash
    make backend-fill-db
    ```
    
    Проверить что база налита можно тут [http://localhost:8002/backend/api/v1/houses/](http://localhost:8002/backend/api/v1/houses/)
    
7. Поднять frontend
    
    ```bash
    # copy .env frontend ## FOR WINDOWS
    cp .env ./frontend/.env
    make run-frontend
    ```
    
    Проверить что он поднялся [http://localhost:3000/house](http://localhost:3000/house)



# OTHER

mkdir prod
cd prod
git clone git@github.com:vanek-goriachev/nikola_mono.git .
git submodule init
git submodule update

-- optional --
cd backend
git checkout main
git pull
cd ..

cd frontend
git checkout main
git pull
cd ..
-- optional block end --


--- nginx and certbot ---
sudo apt update
sudo apt install nginx
sudo service nginx start

// https://certbot.eff.org/instructions
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot
sudo certbot certonly --nginx

TO BE CONTINUED
-- переложить готовый конфиг nginx куда надо
-- перезапустит nginx 
-- поднять все что нужно

... починить gunicorn
... починить проход в админку
... починить общение бэка и фронта
