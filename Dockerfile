FROM php:7.4-apache
MAINTAINER pribytkovskiy.d@gmail.com

ENV VIRTUAL_HOST="dev.apps.neogenos.com" 
ENV APACHE_DOCUMENT_ROOT="/mnt"

# apache user
RUN usermod -u 1000 www-data \
    && groupmod -g 1000 www-data

# extension
RUN apt-get update \
    && apt-get install -y \
        libfreetype6-dev \
        libmagickwand-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libzip-dev \
        jpegoptim \
        optipng \
        gifsicle \
        sendmail \
        git-core \
        build-essential \
        libssl-dev \
        libonig-dev \
        python2.7 \
        zip \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) zip \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install gettext \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mysqli \
    && docker-php-ext-enable mysqli \
    && pecl install xdebug-beta \
        imagick \
    && docker-php-ext-enable xdebug \
    && docker-php-ext-enable imagick \
    && ln -s /usr/bin/python2.7 /usr/bin/python

# ioncube loader
RUN curl -fSL 'http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz' -o ioncube.tar.gz \
    && mkdir -p ioncube \
    && tar -xf ioncube.tar.gz -C ioncube --strip-components=1 \
    && rm ioncube.tar.gz \
    && mv ioncube/ioncube_loader_lin_7.4.so /var/www/ioncube_loader_lin_7.4.so \
    && rm -r ioncube

# composer
RUN curl -S https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && composer self-update

# php.ini
COPY config/php.ini /usr/local/etc/php/

# apache user
RUN usermod -u 1000 www-data \
    && groupmod -g 1000 www-data

# apache
RUN a2enmod rewrite

COPY entrypoint.sh /usr/local/bin/
RUN ["chmod", "+x", "/usr/local/bin/entrypoint.sh"]
EXPOSE 80
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
