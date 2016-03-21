#!/bin/bash

if [ ! -f /etc/default/docker.tcp.forwarded ]
then
    echo "DOCKER_OPTS=\"-H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock --storage-driver=aufs \${DOCKER_OPTS}\"" >> /etc/default/docker
    touch /etc/default/docker.tcp.forwarded
fi

service docker restart
