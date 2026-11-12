# Copies Moodle, put together with the app repository's plugins by
# moodle-install-release in the pipeline, onto wodby/moodle-php, which has
# PHP-FPM and Wodby's setup for Moodle but no Moodle.
ARG WODBY_BASE_IMAGE
FROM ${WODBY_BASE_IMAGE}

ARG COPY_FROM

COPY --chown=wodby:wodby ${COPY_FROM} /var/www/html

RUN set -e; \
    if [ ! -f /var/www/html/lib/setup.php ] || [ ! -f /var/www/html/config.php ]; then \
        echo "Moodle is missing: the pipeline must run 'wodby ci run -- moodle-install-release' before 'wodby ci build'" >&2; \
        exit 1; \
    fi; \
    echo "Moodle $(sed -n "s/^\$release *= *'\([^']*\)'.*/\1/p" /var/www/html/public/version.php)"
