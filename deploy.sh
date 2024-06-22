#!/bin/bash

# Fetch current branch name
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

echo "Current Git Branch: $CURRENT_BRANCH"

# Check if the branch is supported
if [[ "$CURRENT_BRANCH" != "Prod" && "$CURRENT_BRANCH" != "Dev" ]]; then
    echo "Deployment Failed: Unsupported branch $CURRENT_BRANCH"
    exit 1
fi

# Continue with the deployment process
docker-compose down
docker-compose up -d --build

if [ $? -ne 0 ]; then
    echo "Deployment Failed"
    exit 1
else
    echo "Deployment Succeeded"
fi



