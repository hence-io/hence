#!/bin/sh

# Fix for tty warnings while provisioning ubuntu. See: http://foo-o-rama.com/vagrant--stdin-is-not-a-tty--fix.html
sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile
