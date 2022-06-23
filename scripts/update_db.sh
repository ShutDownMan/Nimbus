#!/bin/bash

. .env
echo ${POSTGRES_USER}
echo ${POSTGRES_HOSTNAME}
echo ${POSTGRES_DB}
echo ${POSTGRES_PASSWORD}
# docker exec -it nimbus-postgres-1 "psql postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOSTNAME}:5432/${POSTGRES_DB} -f /docker-entrypoint-initdb.d/setup.sql"
docker exec -it nimbus-postgres-1 "psql postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOSTNAME}:5432/${POSTGRES_DB}"

# psql postgresql://smartfarmer:another!farmer1620.@postgres:5433/SmartFarm?sslmode=require -f /docker-entrypoint-initdb.d/setup.sql

# psql postgresql://smartfarmer:another\!farmer1620.@postgres:5432/SmartFarm -f /docker-entrypoint-initdb.d/setup.sql