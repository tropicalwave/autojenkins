#!/bin/bash

set -e
set -u

function create_user_and_database() {
    local database=$1
    local pw=$2
    echo "  Creating user and database '$database'"
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
        CREATE USER $database;
        ALTER USER $database WITH PASSWORD '$pw';
        CREATE DATABASE $database;
        REVOKE CONNECT ON DATABASE $database FROM PUBLIC;
        GRANT ALL PRIVILEGES ON DATABASE $database TO $database;
EOSQL
}

create_user_and_database gitea "$GITEA_DB_PASSWORD"
create_user_and_database keycloak "$KEYCLOAK_DB_PASSWORD"
