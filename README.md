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
