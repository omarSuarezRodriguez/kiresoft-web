FROM wordpress:latest

# Solo si instalaste paquetes apache extra; si no, omite este RUN
RUN a2dismod -f mpm_event mpm_worker 2>/dev/null || true \
 && a2enmod mpm_prefork 2>/dev/null || true