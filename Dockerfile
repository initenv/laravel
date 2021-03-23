ARG OS_VERSION="3.13"
ARG LANG_VERSION="8.0.2"
FROM php:$LANG_VERSION-fpm-alpine$OS_VERSION

ENV OS_VERSION="3.13"
ENV LANG_VERSION="8.0.2"
ENV APP_VERSION="6.x"
# docker build -t initenv/laravel:$LANG_VERSION-alpine$APP_VERSION .

LABEL maintainer="tokoyi@gmail.com"
LABEL version=$APP_VERSION
LABEL description="Alpine$OS_VERSION + PHP$LANG_VERSION + Composer + Laravel($APP_VERSION LTS) Initially Project"

ENV BASE_DIR="/var/www/html"
ENV PROJECT_HOME="initenv_laravel"


#################################################
# Update Packages List
#################################################
#RUN apk update && mkdir -p $BASE_DIR/$PROJECT_HOME && cd $BASE_DIR/$PROJECT_HOME


#################################################
# Install Package manager (PHP : Composer)
#################################################
#RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/local/bin/composer \
    && composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/


#################################################
# Create Laravel Project
#################################################
RUN cd $BASE_DIR \
    && composer create-project --prefer-dist laravel/laravel $PROJECT_HOME $APP_VERSION
    #&& composer create-project --prefer-dist laravel/lumen test_lumen $APP_VERSION


#################################################
# Clean up
#################################################
#RUN apk del xxx


EXPOSE 8000

WORKDIR $BASE_DIR/$PROJECT_HOME
VOLUME $BASE_DIR/$PROJECT_HOME 


#ENTRYPOINT php artisan serve --host 0.0.0.0


#CMD [ "php", "-S", "0.0.0.0:8000"]
#CMD [ "php", "artisan", "serve", "--host 0.0.0.0"]

CMD cd $BASE_DIR/$PROJECT_HOME \
    && echo '--- OS  Info --------------------------------------------------' \
    && cat /etc/issue \
    && uname -a \
    && date \
    && du -hsx / \
    && echo '--- ENV Info --------------------------------------------------' \
    && php -v \
    && php-fpm -v \
    && composer -V \
    && php artisan -V \
    && echo '--- APP Info --------------------------------------------------' \
    && php artisan serve --host 0.0.0.0 \
    #&& /bin/sh \
