FROM thiagobarradas/lamp:php-7.2
MAINTAINER Thiago Barradas <th.barradas@gmail.com>

# VARIABLES
ENV OPENCART_VERSION=3.0.2.0
ENV ADMIN_USERNAME="admin" 
ENV ADMIN_EMAIL="pribytkovskiy.d@gmail.com" 
ENV ADMIN_PASSWORD="jfyvd7673"

# GET OPENCART FILES
WORKDIR /var/www/html
RUN rm -f * && mkdir tmp
WORKDIR /var/www/html/tmp
RUN ls -l
RUN wget -O opencart-$OPENCART_VERSION.zip https://codeload.github.com/opencart/opencart/zip/$OPENCART_VERSION
RUN chmod -R 755 /app

# UNZIP OPENCART
RUN unzip opencart-$OPENCART_VERSION.zip
WORKDIR /var/www/html/tmp/opencart-$OPENCART_VERSION
RUN composer install
RUN cp -a upload/. /var/www/html
COPY config/config.php /var/www/html/_config.php
COPY config/admin-config.php /var/www/html/admin/_config.php

# CLEAN TMP FILES
RUN rm -rf tmp
RUN apt purge && apt-get autoremove -y && apt-get clean

# COPY SCRIPT TO SETUP OPENCART
COPY scripts/supervisord-zopencart.conf /etc/supervisor/conf.d/supervisord-zopencart.conf
COPY scripts/setup-opencart.sh /setup-opencart.sh

# EXPOSE AND RUN
RUN chmod -R 755 /var/www/html
WORKDIR /var/www/html
EXPOSE 80 3306
CMD ["/run.sh"]
