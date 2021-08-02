#!/bin/sh

# Copyright 2021 Adevinta
set -ev
if [ -z "$1" ]
  then
    echo "docker local tag image specified"
fi

if [ -z "$2" ]
  then
    echo "no image tag to push specified"
fi

LOCAL_TAG=$1
PUSH_TAG=$2
docker tag $LOCAL_TAG $PUSH_TAG
echo ${DOCKER_PASSWORD} | docker login -u $DOCKER_USERNAME --password-stdin
echo "pushing image to repository ${PUSH_TAG}"
docker push $PUSH_TAG
docker logout
