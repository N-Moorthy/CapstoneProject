#!/bin/bash

# Fetching the branch name passed as argument
BRANCH_NAME=$1

echo "Current Git Branch: ${BRANCH_NAME}"

# Stop and remove existing containers
docker-compose down

# Docker login
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

# Docker deployment step
if [[ "${BRANCH_NAME}" == "origin/Prod" ]]; then
    ./build.sh
    docker tag capimg hanumith/prodcapstone:v1
    docker push hanumith/prodcapstone:v1
elif [[ "${BRANCH_NAME}" == "origin/Dev" ]]; then
    ./build.sh
    docker tag capimg hanumith/devcapstone:v1
    docker push hanumith/devcapstone:v1
else
    echo "Deployment Failed: Unsupported branch ${BRANCH_NAME}"
    exit 1
fi

# Start the application
docker-compose up -d