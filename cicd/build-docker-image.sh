#!/bin/bash

######################
## Common Variables ##
######################

CURRENT_FOLDER=$(pwd -P)/$(dirname $0)
SCRIPT_NAME=$(basename $0)
PROJECT_FOLDER=$(pwd -P ${CURRENT_FOLDER}/../)

APP_NAME=$1
ENVIRONMENT_NAME=$2

# Load Common Variables and functions

source ${CURRENT_FOLDER}/common-cicd.sh

BUILD_VERSION=$(extract_version ${JAVA_POM})

###############
## Functions ##
###############

function build_docker_image() {
  APP_NAME=$1
  BUILD_VERSION=$2
  cd $(dirname ${DOCKERFILE})
  docker build \
    --build-arg APP_NAME=${APP_NAME} \
    --build-arg BUILD_VERSION=${BUILD_VERSION} \
    -t $REGISTRY/${APP_NAME}:${BUILD_VERSION} \
    .  
}

function clean_image_list() {
  for ID in $(docker image ls | grep none | awk '{print $3}'); do
    docker rmi -f ${ID}
  done
}

function push_image_to_registry() {
  APP_NAME=$1
  BUILD_VERSION=$2
  docker push ${REGISTRY}/${APP_NAME}:${BUILD_VERSION}
}

##########
## MAIN ##
##########

build_docker_image ${APP_NAME} ${BUILD_VERSION} 
push_image_to_registry ${APP_NAME} ${BUILD_VERSION}
clean_image_list

