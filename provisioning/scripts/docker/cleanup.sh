#!/bin/bash
CRASHED=`docker ps -aq -f exited=1`

echo "INFO: Cleaning up any failed containers"
[ -z "$CRASHED" ] || docker rm -f $CRASHED;
echo "INFO: Cleanup complete"
