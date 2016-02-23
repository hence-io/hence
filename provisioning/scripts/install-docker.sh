#!/bin/bash
DOCKER_VERSION=$1

if [ ! -f /etc/default/docker.${DOCKER_VERSION}.installed ]
then
    apt-get update

    if [ -f /etc/default/docker.tcp.forwarded ]
    then
        apt-get upgrade -y docker-engine=${DOCKER_VERSION}
        rm -f /etc/default/docker /etc/default/docker.tcp.forwarded
    else
        apt-get install -y docker-engine=${DOCKER_VERSION}
    fi

    touch /etc/default/docker.${DOCKER_VERSION}.installed
fi
