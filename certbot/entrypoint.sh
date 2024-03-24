#!/bin/bash

certbot certonly --webroot --webroot-path=/var/www/html -d floppa.space --email you@ele.com --agree-tos --no-eff-email

#sudo chmod -R a+r /etc/letsencrypt
#sudo chmod -R a+r /var/lib/letsencrypt
#sudo chmod -R a+r /var/www/html


trap exit TERM

while :; do
  echo "date : renewing certificates"
  certbot renew
  sleep 12h
done
