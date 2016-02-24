#!/bin/bash
crashed=`docker ps -aq -f exited=1`

echo "INFO: Cleaning up any failed containers"
[ -z "$crashed" ] || docker rm -f $crashed;
echo "INFO: Cleanup complete"


echo "INFO: Removing rancher-server and agent-init containers for reprovisioning"
docker rm -f rancher-server rancher-agent-init
echo "INFO: Rancher container removal complete"
