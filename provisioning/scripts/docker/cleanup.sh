#!/bin/bash
CRASHED=`docker ps -aq -f exited=1`
RANCHER_SERVER=`docker ps -aq -f name=rancher-server`
RANCHER_AGENT_INIT=`docker ps -aq -f name=rancher-agent-init`

echo "INFO: Cleaning up any failed containers"
[ -z "$CRASHED" ] || docker rm -f $CRASHED;
echo "INFO: Cleanup complete"


echo "INFO: Removing rancher-server and agent-init containers for reprovisioning"
[ -z "$RANCHER_SERVER" ] || docker rm -f $RANCHER_SERVER;
[ -z "$RANCHER_AGENT_INIT" ] || docker rm -f $RANCHER_AGENT_INIT;
echo "INFO: Rancher container removal complete"
