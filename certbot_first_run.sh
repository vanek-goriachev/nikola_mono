#/bin/bash!

# Устанавливаем и запускаем nginx с настройками по умолчанию
sudo apt install nginx
sudo systemctl start nginx

# Устанавливаем certbot, получаем сертификаты
sudo apt-get remove certbot
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot
sudo certbot certonly --nginx -d avokado.site --email you@ele.com --agree-tos --no-eff-email


