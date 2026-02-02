# syntax=docker/dockerfile:1.7
FROM debian:stable-slim AS base

ARG APACHE_USER=www-data
ARG APACHE_GROUP=www-data
ARG APACHE_UID=10001
ARG APACHE_GID=10001
ARG TZ=UTC
ENV TZ=${TZ} \
    APACHE_LOG_DIR=/var/log/apache2 \
    APACHE_RUN_DIR=/var/run/apache2 \
    APACHE_LOCK_DIR=/var/lock/apache2 \
    APACHE_PID_FILE=/var/run/apache2/apache2.pid \
    APACHE_DOCUMENT_ROOT=/var/www/html

# Install Apache and common modules
RUN set -eux; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      apache2 \
      apache2-utils \
      ca-certificates \
      curl \
      dumb-init \
      openssl \
      tzdata \
      # modules
      libapache2-mod-security2 \
      libapache2-mod-fcgid; \
    rm -rf /var/lib/apt/lists/*

# Enable useful modules
RUN set -eux; \
    a2enmod rewrite headers ssl proxy proxy_http proxy_fcgi deflate env expires mime setenvif slotmem_shm socache_shmcb status; \
    a2dismod mpm_prefork || true; \
    a2enmod mpm_event

# Create non-root user/group (avoid default 33/33 collisions)
RUN set -eux; \
    groupadd -g ${APACHE_GID} ${APACHE_GROUP}; \
    useradd -u ${APACHE_UID} -g ${APACHE_GID} -M -s /usr/sbin/nologin ${APACHE_USER}; \
    install -d -o ${APACHE_UID} -g ${APACHE_GID} ${APACHE_DOCUMENT_ROOT} ${APACHE_RUN_DIR} ${APACHE_LOG_DIR}

# Copy config & content (allow override via bind-mounts)
COPY --chown=${APACHE_UID}:${APACHE_GID} conf/httpd.conf /etc/apache2/apache2.conf
COPY --chown=${APACHE_UID}:${APACHE_GID} conf/mpm_event.conf /etc/apache2/mods-available/mpm_event.conf
COPY --chown=${APACHE_UID}:${APACHE_GID} conf/security.conf /etc/apache2/conf-available/security.conf
COPY --chown=${APACHE_UID}:${APACHE_GID} conf/extras/headers_hsts.conf /etc/apache2/conf-available/headers_hsts.conf
COPY --chown=${APACHE_UID}:${APACHE_GID} conf/sites/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY --chown=${APACHE_UID}:${APACHE_GID} conf/sites/001-ssl.conf /etc/apache2/sites-available/001-ssl.conf
COPY --chown=${APACHE_UID}:${APACHE_GID} html/ ${APACHE_DOCUMENT_ROOT}/

# Healthcheck script
COPY --chmod=0755 healthcheck.sh /usr/local/bin/healthcheck.sh
# Entrypoint
COPY --chmod=0755 entrypoint.sh /usr/local/bin/entrypoint.sh

# Enable site and security extras
RUN set -eux; \
    a2enconf security headers_hsts || true; \
    a2ensite 000-default; \
    # don't enable SSL site unless certs are present; can be enabled via env in entrypoint
    true

EXPOSE 80 443

HEALTHCHECK --interval=30s --timeout=3s --retries=3 CMD ["/usr/local/bin/healthcheck.sh"]

USER ${APACHE_UID}:${APACHE_GID}

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/usr/local/bin/entrypoint.sh"]
