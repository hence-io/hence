#!/bin/bash

rm /usr/local/bin/rancher-compose\
&& curl -L https://github.com/rancher/rancher-compose/releases/download/v0.2.5/rancher-compose-darwin-amd64-v0.2.5.tar.gz\
| tar xzf - -C /usr/local/bin --strip-components 2\
&& chmod +x /usr/local/bin/rancher-compose
