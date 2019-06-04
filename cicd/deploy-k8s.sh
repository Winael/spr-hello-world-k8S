#!/bin/bash

###################
## Deploy on K8s ##
###################

######################
## Common Variables ##
######################

CURRENT_FOLDER=$(pwd -P)/$(dirname $0)
SCRIPT_NAME=$(basename $0)
PROJECT_FOLDER=$(pwd -P ${CURRENT_FOLDER}/../)
BUILD_RESOURCE_FOLDER=${PROJECT_FOLDER}/.build.k8s
K8S_RESOURCES_TEMPLATES_FOLDER=${PROJECT_FOLDER}/k8s.templates

APP_NAME=$1
ENVIRONMENT_NAME=$2

# Load Common Variables and functions

source ${CURRENT_FOLDER}/common-cicd.sh

BUILD_VERSION=$(extract_version ${JAVA_POM})

###############
## Functions ##
###############

function generate_k8s_resource() {
  APP_NAME=$1
  BUILD_VERSION=$2
  
  mkdir -p ${BUILD_RESOURCE_FOLDER}

  for FILE in $(ls ${K8S_RESOURCES_TEMPLATES_FOLDER}); do
    sed \
      -e \
      "s/APP_NAME/${APP_NAME}/g" \
      ${K8S_RESOURCES_TEMPLATES_FOLDER}/${FILE} \
      | tee ${BUILD_RESOURCE_FOLDER}/${FILE} 
    sed \
      -i \
      -e \
      "s/BUILD_VERSION/${BUILD_VERSION}/g" \
      ${BUILD_RESOURCE_FOLDER}/${FILE} 
    sed \
      -i \
      -e \
      "s/REGISTRY/${REGISTRY}/g" \
      ${BUILD_RESOURCE_FOLDER}/${FILE}
  done
}

function apply_k8s_resources() {
  for FILE in $(ls ${BUILD_RESOURCE_FOLDER}); do
    microk8s.kubectl apply -f ${BUILD_RESOURCE_FOLDER}/${FILE}
  done
}

##########
## MAIN ##
##########

generate_k8s_resource ${APP_NAME} ${BUILD_VERSION}
apply_k8s_resources
