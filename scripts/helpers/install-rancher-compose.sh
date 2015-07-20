#!/bin/bash

rm /usr/local/bin/rancher-compose\
&& curl -L https://github.com/rancher/rancher-compose/releases/download/v0.1.3/rancher-compose-darwin-amd64-v0.1.3.tar.gz\
| tar xzf - -C /usr/local/bin --strip-components 2\
&& chmod +x /usr/local/bin/rancher-compose
