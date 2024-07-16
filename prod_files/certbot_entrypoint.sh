#!/bin/bash

mkdir -p /var/www/html/.well-known/acme-challenge/
chmod -R a+r /var/www/html

mkdir -p /etc/letsencrypt/
chmod -R a+r /etc/letsencrypt

#Я переместил этот кусок кода и файл который он генерит в контейнер nginx
#Кажется ничего не должно сломаться, но оставлю этот кусок кода пока закомментированным
#DH_PARAMS_FILE="/etc/letsencrypt/ssl-dhparams.pem"
#
## Проверяем, существует ли файл
#if [ ! -f "$DH_PARAMS_FILE" ]; then
#  echo "$(date) Файл $DH_PARAMS_FILE не найден. Генерируем новый..."
#  echo "$(date) Это может занять около 5 минут когда запускается внутри контейнера"
#  openssl dhparam -out "$DH_PARAMS_FILE" 4096 > /dev/null 2>&1
#  echo "$(date) Файл $DH_PARAMS_FILE успешно сгенерирован."
#else
#  echo "$(date) Файл $DH_PARAMS_FILE уже существует. Пропускаем генерацию."
#fi

certbot certonly -v --webroot --webroot-path=/var/www/html -d example.com --email you@ele.com --agree-tos --no-eff-email


trap "echo 'Received TERM signal, exiting...'; exit" TERM

while :; do
 echo "date : renewing certificates"
 certbot renew
 sleep 12h
done
