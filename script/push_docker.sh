#!/bin/sh

# Copyright 2021 Adevinta
set -ev
if [ -z "$1" ]
  then
    echo "no docker image repository specified"
fi
IMAGE_REPOSITORY=$1
echo "pushing image to repository ${IMAGE_REPOSITORY}"
echo ${DOCKER_PASSWORD} | docker login -u $DOCKER_USERNAME --password-stdin
docker push $IMAGE_REPOSITORY
docker logout
