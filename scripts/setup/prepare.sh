#!/bin/bash

if [ -z "$(which docker)" ]
then
    apt-get update -qqy
fi
