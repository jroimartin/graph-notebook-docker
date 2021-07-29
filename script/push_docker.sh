#!/bin/sh

# Copyright 2021 Adevinta
set -ev
DOCKER_IMAGE_RELEASE=adevinta/graph-notebook:$TRAVIS_TAG
docker image tag $DEV_IMAGE_REPOSITORY $DOCKER_IMAGE_RELEASE
echo ${DOCKER_PASSWORD} | docker login -u $DOCKER_USERNAME --password-stdin $DOCKER_IMAGE_RELEASE
