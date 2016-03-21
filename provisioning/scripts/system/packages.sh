#!/bin/bash
apt-get update
apt-get install -y htop tree lsyncd ncdu apparmor
apt-get install -y linux-image-extra-$(uname -r)
