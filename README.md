# Hence
Provisioner for the Hence.io platform

## Installation Instructions
### Local requirements
* Vagrant 1.7.2+
* Virtualbox 4.3.0+
* Docker 1.7.0+  ( Optional, if you want to run docker commands against containers without SSH-ing into the vm node(s) )

If you want to use Vagrant to run this on your laptop just clone the repo and to do `vagrant up` and then access port 8080 for the UI.

The UI and API are available on the exposed port `8080`.

### Launching the VM
Clone this repo and run

`vagrant up`

### Using Rancher

The hence project relies heavily on rancher for container/service scheduling and discovery

To learn more about using Rancher, please refer to the [Rancher Documentation](http://docs.rancher.com/).

### Setting up Rancher Compose CLI
#### OSX
    rm /usr/local/bin/rancher-compose\
    && curl -L https://github.com/rancher/rancher-compose/releases/download/v0.1.3/rancher-compose-darwin-amd64-v0.1.3.tar.gz\
    | tar xzf - -C /usr/local/bin --strip-components 2\
    && chmod +x /usr/local/bin/rancher-compose

### Setting up Local Docker to version 1.7
#### OSX
    rm /usr/local/bin/docker\
    && curl -L https://get.docker.com/builds/Darwin/x86_64/docker-latest > /usr/local/bin/docker\
    && chmod +x /usr/local/bin/docker
