sleep 30

php /app/install/cli_install.php install --db_hostname 10.0.0.2 --db_username fast_oc2 --db_password L@sVega$ --db_database fast_oc2 --db_driver mysqli --username $ADMIN_USERNAME --password $ADMIN_PASSWORD --email $ADMIN_EMAIL --http_server https://dev.dejafashion.neogenos.com

rm -f /app/config.php /app/config-dist.php
mv /app/_config.php /app/config.php
rm -f /app/admin/config.php /app/admin/config-dist.php
mv /app/admin/_config.php /app/admin/config.php
mkdir /app-pvt && mkdir /app-pvt/storage 
mv /app/system/storage/* /app-pvt/storage
rm -rf /app/install

chmod -R 755 /app /app-pvt
rm -f /etc/supervisor/conf.d/supervisord-zopencart.conf