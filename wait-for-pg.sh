#!/bin/bash
# Yo. Waits until Postgres is ready, or bails after 2 minutes.

timeout=120

until echo $USER_PASSWORD | sudo -S docker-compose run db psql -h 'db' -U 'postgres' -c '\l' ; do
  if [[ $((timeout)) -eq 0 ]]; then
    >&2 echo "Postgres took too long to respond - timeout"
    exit 1
  fi

  >&2 echo "Postgres is unavailable - sleeping"
  timeout=$(($timeout - 1))

  sleep 1
done

>&2 echo "Postgres is up - executing command"
