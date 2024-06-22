#!/bin/bash

# Fetching the current Git branch
GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo "Current Git Branch: ${GIT_BRANCH}"

# Stop and remove existing containers
docker-compose down

# Docker Prod step
if [[ "${GIT_BRANCH}" == "Prod" ]]; then
    ./build.sh
    docker tag capimg hanumith/prodcapstone:v1
    docker push hanumith/prodcapstone:v1

elif [[ "${GIT_BRANCH}" == "Dev" ]]; then
    ./build.sh
    docker tag capimg hanumith/devcapstone:v1
    docker push hanumith/devcapstone:v1

else
    echo "Deployment Failed: Unsupported branch ${GIT_BRANCH}"
fi



