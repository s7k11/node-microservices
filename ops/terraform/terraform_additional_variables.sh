#!/usr/bin/env bash

if [ -z "${DB_NAME}" ]; then
    log ERROR "Please set environment variable DB_NAME for RDS DB name .";
    exit 1;
fi

export TF_VAR_DB_NAME=${DB_NAME}
export TF_VAR_DB_USER_CONFIG_KEY="/${CIRCLE_PROJECT_REPONAME}/${EB_ENVIRONMENT}/dbuser"
export TF_VAR_DB_PASSWORD_CONFIG_KEY="/${CIRCLE_PROJECT_REPONAME}/${EB_ENVIRONMENT}/dbpassword"
