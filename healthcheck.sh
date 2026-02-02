et -eu
URL="${HEALTHCHECK_URL:-http://127.0.0.1/}"
exec curl -fsS --max-time 2 "$URL" >/dev/null
