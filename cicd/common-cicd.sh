#!/bin/bash

######################
## Common Variables ##
######################

# colors for printing

RED='\033[1;31m'
BLUE='\033[0;36m'
NC='\033[0m' # No Color

JAVA_SRC=$(pwd -P ${PROJECT_FOLDER})/src
JAVA_POM=$(pwd -P ${PROJECT_FOLDER})/pom.xml
DOCKERFILE=$(pwd -P ${PROJECT_FOLDER})/Dockerfile

case ${ENVIRONMENT_NAME} in

  local)
    REGISTRY="localhost:32000"
    ;;

esac

######################
## Common Functions ##
######################

function info() {
  printf "${BLUE}${@}${NC}\n"
}

function error() {
  printf "${RED}${@}${NC}\n"
}

# Print the error ($2) and the exit code ($1)
function exit_error() {
  error $@
  exit 1
}

# Extract the version from pom.xml
function extract_version() {
  grep -oPm1 "(?<=<version>)[^<]+" $1
}

