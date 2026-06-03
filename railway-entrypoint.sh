#!/bin/sh
set -e

# Un solo MPM (WordPress + mod_php necesita prefork)
a2dismod -f mpm_event mpm_worker 2>/dev/null || true
rm -f /etc/apache2/mods-enabled/mpm_event.load \
      /etc/apache2/mods-enabled/mpm_event.conf \
      /etc/apache2/mods-enabled/mpm_worker.load \
      /etc/apache2/mods-enabled/mpm_worker.conf
a2enmod mpm_prefork

# Puerto que Railway asigna
PORT="${PORT:-8080}"
sed -i "s/Listen 80/Listen ${PORT}/" /etc/apache2/ports.conf
sed -i "s/:80>/:${PORT}>/" /etc/apache2/sites-enabled/000-default.conf 2>/dev/null || true
sed -i "s/:80 /:${PORT} /" /etc/apache2/sites-enabled/000-default.conf 2>/dev/null || true

exec docker-entrypoint.sh "$@"