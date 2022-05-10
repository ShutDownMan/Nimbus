# Nimbus

This is the backend server for the SmartFarm project.

It's a docker compose image with the service and database.

The service is written in node with typescript, express for endpoint handling and prisma for Object Relational Mapping.

The database used is PostgreSQL and designed using pgmodeler.

## Running

In order to run this code you must have docker installed.

Dont forget to setup the needed enviroment variables.

Execute by running `docker-compose up` in the root directory of this repository.
