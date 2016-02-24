#!/bin/bash
PROVISION_TIMESTAMP=$1

docker logs -f --since ${PROVISION_TIMESTAMP} rancher-agent-init
