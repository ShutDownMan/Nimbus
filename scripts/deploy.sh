#!/bin/bash

git pull

docker-compose stop
docker-compose up -d && docker-compose logs --follow
