#!/bin/bash

rm /usr/local/bin/docker\
&& curl -L https://get.docker.com/builds/Darwin/x86_64/docker-1.7.1 > /usr/local/bin/docker\
&& chmod +x /usr/local/bin/docker
