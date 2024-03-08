FROM nginx:1.19.0-alpine as production

# Копируем nginx конфиг
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Запускаем NGINX
CMD ["nginx", "-g", "daemon off;"]
