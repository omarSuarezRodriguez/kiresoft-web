#!/bin/sh
set -e

# Quita TODOS los MPM
for m in event worker prefork; do
  a2dismod -f "mpm_${m}" 2>/dev/null || true
done
rm -f /etc/apache2/mods-enabled/mpm_*.load /etc/apache2/mods-enabled/mpm_*.conf

# Solo prefork (WordPress + mod_php)
ln -sf /etc/apache2/mods-available/mpm_prefork.load /etc/apache2/mods-enabled/mpm_prefork.load
ln -sf /etc/apache2/mods-available/mpm_prefork.conf /etc/apache2/mods-enabled/mpm_prefork.conf

# Puerto Railway
PORT="${PORT:-8080}"
sed -i "s/Listen 80/Listen ${PORT}/" /etc/apache2/ports.conf
sed -i "s/:80/:${PORT}/g" /etc/apache2/sites-enabled/000-default.conf 2>/dev/null || true

# Diagnóstico en logs (debe salir UNA línea mpm_*)
apache2ctl -M 2>&1 | grep mpm || true
apache2ctl configtest

exec docker-entrypoint.sh apache2-foreground