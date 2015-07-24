#!/bin/bash

if [ ! -f /etc/default/docker.tcp.forwarded ]
then
    echo "DOCKER_OPTS=\"-H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock \${DOCKER_OPTS}\"" >> /etc/default/docker
    touch /etc/default/docker.tcp.forwarded
    if [ -n "$(which docker)" ]; then service docker restart; fi
fi
