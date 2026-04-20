#!/bin/bash

set -e

# Wait for MySQL to be ready
# if [ "$DB_CONNECTION" = "mysql" ]; then
#     echo "Waiting for MySQL..."
#     until mysql -h "$DB_HOST" -u "$DB_USERNAME" -p"$DB_PASSWORD" -e "SELECT 1" &>/dev/null; do
#         sleep 1
#     done
#     echo "MySQL is ready!"
# fi

# Run migrations
php artisan migrate --force

# Clear and rebuild caches
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Start supervisor (handles PHP-FPM and Nginx)
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
