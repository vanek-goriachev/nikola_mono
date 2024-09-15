# Ultimate Deploy Guide

## Предварительная подготовка

### Сеть, IP, DNS

1. Создать виртуальную машину с белым IP адресом  `1.2.34.56`
2. Купить доменное имя `example.com`
3. Связать белый ip `1.2.34.56` с доменным именем `example.com`

### Сборка приложения

1. Если container-registry от Яндекса - установить локально yc-cli и [настроить push докер образов в registry](https://yandex.cloud/ru/docs/container-registry/quickstart/?from=int-console-empty-state&utm_referrer=https%3A%2F%2Fconsole.yandex.cloud%2Ffolders%2Fb1g5khohqisljdrrfr5n%2Fcontainer-registry%2Fregistries%2Fcrpll06klmdrn2f8jpuj%2Foverview)
Если не от Яндекса - авторизоваться в этом registry, чтобы можно было пушить docker images
2. Скачать локально репозиторий 
    
    ```bash
    git clone git@github.com:vanek-goriachev/nikola_mono.git
    cd nikola_mono
    git submodule init
    git submodule update
    ```
    
3. Заполнить файл .env который будет использоваться для сборки приложения
    1. Скопировать его
        
        ```bash
        # copy .env.example .env ## FOR WINDOWS
        cp .env.example .env
        ```
        
    2. Заполнить поля ко
        
        ```bash
        FRONTEND_HOST="floppa.space"
        NEXT_PUBLIC_YANDEX_METRIKA_COUNTER_ID="97893037"
        ```
        
4. Собрать и запушить образы в registry
    1. Сохранить registry_url в переменной
        
        ```bash
        # $CONTAINER_REGISTRY_URL="cr.yandex/crpll06klmdrn2f8jpuj" ## FOR WINDOWS
        export CONTAINER_REGISTRY_URL="cr.yandex/crpll06klmdrn2f8jpuj"
        ```
        
    2. Собрать и запушить backend образ
        
        ```bash
        # $BACKEND_IMAGE_TAG="v1" ## FOR WINDOWS
        export BACKEND_IMAGE_TAG="v1"  # change tag on update
        make build-backend
        docker tag nikola/backend:latest $CONTAINER_REGISTRY_URL/backend:$BACKEND_IMAGE_TAG
        docker push $CONTAINER_REGISTRY_URL/backend:$BACKEND_IMAGE_TAG
        ```
        
    3. Собрать и запушить frontend образ
        
        Note: в docker image фронтенда записывается [example.com](http://example.com) из .env файла, поэтому стоит пометить образ добавив после v1 example.com 
        
        ```bash
        # $FRONTEND_IMAGE_TAG="v1-example.com" ## FOR WINDOWS
        export FRONTEND_IMAGE_TAG="v1-example.com"  # change tag on update
        make build-frontend
        docker tag nikola/frontend:latest $CONTAINER_REGISTRY_URL/frontend:$FRONTEND_IMAGE_TAG
        docker push $CONTAINER_REGISTRY_URL/frontend:$FRONTEND_IMAGE_TAG
        ```
        
    4. Собрать и запушить образ nginx_with_brotli
        
        ```bash
        # $NGINX_IMAGE_TAG="v1" ## FOR WINDOWS
        export NGINX_IMAGE_TAG="v1"  # change tag on update
        make build-nginx_with_brotli
        docker tag nikola/nginx_with_brotli:latest $CONTAINER_REGISTRY_URL/nginx_with_brotli:$NGINX_IMAGE_TAG
        docker push $CONTAINER_REGISTRY_URL/nginx_with_brotli:$NGINX_IMAGE_TAG
        ```
        

### Внешние приложения (redis, postgres)

1. На момент написания инструкция подразумевает, что redis поднимается сам (в docker compose), а postgres поднят как отдельный сервер заранее и от него известны все логины и пароли.
    
    Note: у postgreSQL должно быть расширение `btree_gist`
    

### Переменные окружения, которые лучше найти заранее

1. Телеграм бот - завести через [https://t.me/BotFather](https://t.me/BotFather) и скопировать API ключ
2. manager chat id - создать группу в телеграмм и переслать одно любое сбщ из нее в бота [https://t.me/getmyid_bot](https://t.me/getmyid_bot). В ответе скопировать поле “Forwarded from:”
3. Email - адрес с которого будет происходить рассылка писем
    1. Завести аккаунт
    2. Для данного аккаунта открыть Google App Passwords - [https://myaccount.google.com/u/1/apppasswords](https://myaccount.google.com/u/1/apppasswords) и создать там пароль который будет использоваться для email рассылки
    Note: для создания пароля требуется включить двухэтапную аутентификацию
4. Завести новый счетчик яндекс метрики - скопировать его ID

### Сервер

1. Подключиться к серверу по ssh (в случае с Яндексом - можно использовать yc-cli)
2. Установить docker
    
    ```bash
    sudo snap install docker
    ```
    
3. Создать папку, в которой будет вестись работа
    
    ```bash
    mkdir prod && cd prod
    ```
    
4. Копируем с гитхаба файлы необходимые для запуска сервера
    1. При необходимости авторизуемся
        1. Создаем ssh ключ на сервере
            
            ```bash
            ssh-keygen -t rsa
            ```
            
        2. Копируем публичный ключ
            
            ```bash
            cat ~/.ssh/id_rsa.pub
            ```
            
        3. Вставляем его в настройки гитхаб аккаунта в раздел ssh ключи
    2. Клонируем репозиторий
        
        ```bash
        git clone git@github.com:vanek-goriachev/nikola_prod_files.git .
        ```
        
5. Заменим во всех файлах доменное имя на доменное имя нашего сайта
    1. Делаем replace_example_com.sh исполняемым
        
        ```bash
        chmod +x replace.sh
        ```
        
    2. Запускаем
        
        ```bash
        ./replace.sh "[example.com](http://example.com/)" "mydomain.com"
        ./replace.sh "[example](http://example.com/)@email" "my@email"
        ```
        
6. Вписать правильные поля в .env файл
    1. Скопировать файл
        
        ```bash
        cp .env.example .env
        ```
        
    2. Отредактировать файл (в нем указаны комментарии какая переменная за что отвечает и как ее заполнить)
    Перемещение по файлу стрелочками
    Сохранить файл `Ctrl+X` + `y` + `Enter`
        
        ```bash
        nano .env
        ```
        
7. Создать сеть docker по которой будут общаться контейнеры
    
    ```bash
    docker network create nikola-docker-network
    ```
    
8. Авторизоваться в container registry чтобы иметь возможность скачивать оттуда образы. Вот [инструкция от yandex cloud](https://yandex.cloud/ru/docs/container-registry/operations/authentication) (для яндексового registry)
9. Запустить сервисы
    1. `sudo docker-compose --profile core up -d`
    2. `sudo docker-compose --profile nginx-certbot up -d`
        
        Убедиться что все хорошо почитав логи `sudo docker logs certbot`
        
    3. Остановить контейнер с `nginx-temporary`, поднять контейнеры мониторинга и контейнер `nginx`
        
        ```bash
        sudo docker rm -f nginx-temporary
        sudo docker-compose -f monitoring/monitoring.yml up --build -d
        sudo docker-compose up nginx --build -d
        ```
        

# ПОЗДРАВЛЯЮ! ПРОД ПОДНЯТ!

Теперь нужно завести несколько аккаунтов и наполнить систему данными

1. Создадим аккаунт администратора
    
    ```bash
     sudo docker exec -it backend bash
     python manage.py createsuperuser
    ```
    
    1. По созданному логину и паролю зайти в панель администратора и наполнить необходимыми данными базу [nikola-lenivets.site/backend/admin](http://nikola-lenivets.site/backend/admin) 
        1. Houses [https://nikola-lenivets.site/backend/admin/houses/house/](https://nikola-lenivets.site/backend/admin/houses/house/) 
        2. AdditionalServices [https://nikola-lenivets.site/backend/admin/additional_services/additionalservice/](https://nikola-lenivets.site/backend/admin/additional_services/additionalservice/) 
2. Залогинимся в мониторинг
    1. [https://nikola-lenivets.site/monitoring/grafana/login](https://nikola-lenivets.site/monitoring/grafana/login) (`admin`, `password`)
    2. Создать дашборды мониторинга
        1. Зайти на страницу [https://nikola-lenivets.site/monitoring/grafana/connections/datasources/new](https://nikola-lenivets.site/monitoring/grafana/connections/datasources/new) и добавить prometheus data source
        url: [`http://prometheus:9090/monitoring/prometheus`](http://prometheus:9090/monitoring/prometheus)
        2. Далее скачать отсюда дашборд
        [https://grafana.com/grafana/dashboards/1860-node-exporter-full/](https://grafana.com/grafana/dashboards/1860-node-exporter-full/)
        3. Далее на этой странице
        [https://nikola-lenivets.site/monitoring/grafana/dashboards](https://nikola-lenivets.site/monitoring/grafana/dashboards) 
        В правом верхнем углу импортировать скачанный на предыдущем шаге дашборд
3. Тут можно просмотреть успешность выполнения celery тасок (отправка email и уведомления менеджеру)
[https://nikola-lenivets.site/backend/flower/tasks](https://nikola-lenivets.site/backend/flower/tasks)
4. Рекомендуется обновить `sitemap.xml` и `robots.txt` на актуальные
    
    ```bash
    cd ~/prod/SEO
    nano sitemap.xml
    ```
    

# Обновление приложения

1. Собрать локально контейнеры и запушить их в registry (как в этом [блоке](https://www.notion.so/Ultimate-Deploy-Guide-1021ab4dd7c3809c80b1fbb98d3a5121?pvs=21))
2. Если обновляется frontend - обязательно нужно пересоздать `volumes` . Для этого нужно удалить старые.
    
    ```bash
    sudo docker stop frontend && \
    sudo docker rm frontend && \
    sudo docker stop nginx && \
    sudo docker rm nginx && \
    sudo docker volume rm prod_app_next
    ```
    
3. Если обновляется backend - иногда требуется пересоздать `volumes` . Для этого нужно удалить старые.
    
    ```bash
    sudo docker stop backend && \
    sudo docker rm backend && \
    sudo docker stop celery-workers && \
    sudo docker rm celery-workers && \
    sudo docker stop flower && \
    sudo docker rm flower && \
    sudo docker stop nginx && \
    sudo docker rm nginx && \
    sudo docker volume rm prod_backend_media prod_backend_static
    ```
    
4. Дальше нужно прописать в `.env` файле актуальные теги образов при помощи команды `nano .env`
5. Дальше нужно запустить контейнеры
    
    ```bash
    sudo docker-compose --profile core up -d 
    sudo docker-compose up nginx -d
    ```
    

# Ссылка-ссылки-ссылки

1. Сайт - [nikola-lenivets.site](http://nikola-lenivets.site) 
2. Админ панель - [nikola-lenivets.site/backend/admin](http://nikola-lenivets.site/backend/admin) 
3. Список тасок (на отправку уведомлений) - [nikola-lenivets.site/backend/flower](http://nikola-lenivets.site/backend/flower) 
4. Прометеус - [nikola-lenivets.site/monitoring/prometheus](http://nikola-lenivets.site/monitoring/prometheus) 
5. Grafana - [nikola-lenivets.site/monitoring/grafana](http://nikola-lenivets.site/monitoring/grafana) 
6. Яндекс метрика [https://metrika.yandex.ru/overview?id=98343309](https://metrika.yandex.ru/overview?id=98343309) 
7. Чат с уведомлениями тг …
8. Почтовый адрес …

# (may be outdated) Инструкция по локальному запуску проекта

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
    
3. Рекомендуется убедиться, что у вас не остается никакого кэша, volumes, images etc с предыдущих сборок
    
    ```bash
    docker volume ls
    docker images
    ```
    
4. При локальной разработке если не переопределены в .env параметры для внешних сервисов (postgres, redis), то потребуется поднять локальные докер контейнеры с ними
    1. redis
        
        ```bash
        make run-redis
        ```
        
    2. postgres
        
        ```bash
        make run-postgres
        ```
        
5. Поднять backend
    
    ```bash
    make run-backend
    ```
    
    После этого следует зайти на [http://localhost:8002/backend/admin/](http://localhost:8002/backend/admin/login/?next=/backend/admin/) и убедиться что сервис поднят
    
6. Создать пользователя-админа в backend
    
    ```bash
    make backend-create-superuser
    ```
    
7. При необходимости налить базу данных бэкенда
    
    ```bash
    make backend-fill-db
    ```
    
    Проверить что база налита можно тут [http://localhost:8002/backend/api/v1/houses/](http://localhost:8002/backend/api/v1/houses/)
    
8. Поднять frontend (можно поднять frontend отдельно от локального backend, указав в .env нужные URL)
    
    ```bash
    # copy .env frontend ## FOR WINDOWS
    make run-frontend
    ```
    
    Проверить что он поднялся [http://localhost:3000/house](http://localhost:3000/house)