#!/bin/bash

if [ -z "$(which docker)" ]
then
    apt-get update -qqy
fi

if [ ! -f /etc/default/docker.install.prepared ]
then
  # Re-installing docker-engine from the new repo will require any existing vm's to re-forward the tcp
  rm /etc/default/docker.tcp.forwarded

  # add the new gpg key
  apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

  # edit your /etc/apt/sources.list.d/docker.list
  touch /etc/apt/sources.list.d/docker.list
  echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list

  apt-get update

  # remove the old
  apt-get purge -y lxc-docker*

  touch /etc/default/docker.install.prepared
fi
