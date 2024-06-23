#!/bin/bash

#Docker BuildKit Enabling
export DOCKER_BUILDKIT=1

#Docker image build step
docker build -t capimg .

#Docker compose file for container
docker-compose up -d 

