#!/bin/bash

#Docker image build step
docker build -t capimg .

#Docker compose file for container
docker-compose up -d 

