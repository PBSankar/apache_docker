#!/usr/bin/env bash
set -euo pipefail

ENABLE_SSL=${ENABLE_SSL:-false}

# Debian vs Alpine paths
if command -v a2ensite >/dev/null 2>&1; then
  # Debian
  if [[ "${ENABLE_SSL}" == "true" ]]; then
    a2enmod ssl >/dev/null 2>&1 || true
    a2ensite 001-ssl >/dev/null 2>&1 || true
  else
    a2dissite 001-ssl >/dev/null 2>&1 || true
  fi
  exec /usr/sbin/apache2ctl -D FOREGROUND
else
  # Alpine
  if [[ "${ENABLE_SSL}" == "true" ]]; then
    # Ensure SSL module is loaded (alpine package apache2-ssl handles this)
    true
  fi
  exec /usr/sbin/httpd -D FOREGROUND -f /etc/apache2/httpd.conf
fi