FROM ubuntu:24.04 as builder

RUN apt update \
    && apt upgrade -y \
    && apt install -y libpcre3 libpcre3-dev zlib1g zlib1g-dev openssl libssl-dev wget git gcc make libbrotli-dev

WORKDIR /app

# generate /app/ssl-dhparams.pem
RUN DH_PARAMS_FILE="/app/ssl-dhparams.pem" && \
    if [ ! -f "$DH_PARAMS_FILE" ]; then \
      echo "$(date) Файл $DH_PARAMS_FILE не найден. Генерируем новый..."; \
      echo "$(date) Это может занять около 5 минут когда запускается внутри контейнера"; \
      openssl dhparam -out "$DH_PARAMS_FILE" 4096 > /dev/null 2>&1; \
      echo "$(date) Файл $DH_PARAMS_FILE успешно сгенерирован."; \
    else \
      echo "$(date) Файл $DH_PARAMS_FILE уже существует. Пропускаем генерацию."; \
    fi

RUN wget https://nginx.org/download/nginx-1.25.5.tar.gz && tar -zxf nginx-1.25.5.tar.gz
RUN git clone --recurse-submodules -j8 https://github.com/google/ngx_brotli
RUN cd nginx-1.25.5 && ./configure --with-compat --add-dynamic-module=../ngx_brotli \
    && make modules

FROM nginx:1.25.5
COPY --from=builder /app/nginx-1.25.5/objs/ngx_http_brotli_static_module.so /etc/nginx/modules/
COPY --from=builder /app/nginx-1.25.5/objs/ngx_http_brotli_filter_module.so /etc/nginx/modules/

# copy /app/ssl-dhparams.pem
COPY --from=builder /app/ssl-dhparams.pem /etc/nginx/conf.d/
# in nginx.conf file you shoul use `include /etc/nginx/conf.d/common_ssl.conf`
COPY common_ssl.conf /etc/nginx/conf.d/

RUN echo "load_module modules/ngx_http_brotli_filter_module.so;\nload_module modules/ngx_http_brotli_static_module.so;\n$(cat /etc/nginx/nginx.conf)" > /etc/nginx/nginx.conf
RUN echo 'brotli on;\n \
brotli_comp_level 6;\n \
brotli_static on;\n \
brotli_types application/atom+xml application/javascript application/json application/rss+xml\n \
          application/vnd.ms-fontobject application/x-font-opentype application/x-font-truetype\n \
          application/x-font-ttf application/x-javascript application/xhtml+xml application/xml\n \
          font/eot font/opentype font/otf font/truetype image/svg+xml image/vnd.microsoft.icon\n \
          image/x-icon image/x-win-bitmap text/css text/javascript text/plain text/xml;' > /etc/nginx/conf.d/brotli.conf

RUN echo 'gzip_static on; \
gzip on; \
gzip_comp_level 5; \
gzip_types image/jpeg image/png;' > /etc/nginx/conf.d/gzip.conf \
