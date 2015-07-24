#!/bin/bash

if [ ! -f /etc/default/docker ]
then
    echo DOCKER_OPTS="-H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock ${DOCKER_OPTS}" > /etc/default/docker
fi
