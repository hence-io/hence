# Hence
Vagrant provisioner for a Hence.io platform VM

**NOTE:** This platform is intended to be installed and managed using our [Hence CLI](https://github.com/hence-io/cli) nodejs package. It is by far the easiest and quickest way to provision and manage a Hence VM. We recommend that you use it instead of installing manually from this repo.

## Prerequisites
* Vagrant 1.7.2+
* Virtualbox 4.3.0+

## Recommended Vagrant Plugins
* [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest)
* [vagrant-gatling-rsync](https://github.com/smerrill/vagrant-gatling-rsync)
* [vagrant-hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater)

## What it provides
A basic vagrant up and provision will provide:

_VM Host_
* Ubuntu 14.04 OS
* Docker 1.7.1 (with TCP forwarding to port 2375)


_Rancher_ (Docker container management infrastructure.  [Homepage](http://rancher.com/rancher/) | [Docs](http://docs.rancher.com/))
* Rancher Server instance
* Rancher Agent instance
* Rancher UI


## CLI Installation Method (recommended)
You can get started by running:

`npm install -g hence-cli`

It is highly recommended that you have a look at the [Quick Start Guide](https://github.com/hence-io/cli#quick-start-guide) and go through the entire process.

## Manual Installation Method (if you must)
### 1. Install and provision the vm
You can start and provision a VM by cloning this repo and running:

`vagrant up`

### 2. Launch the Rancher dashboard
For the default installation, it should be available at http://172.19.8.100:8080 (Linux, OSx, Windows), or http://hence:8080 (Linux, OSx).

### 3. Connect with the Rancher API
This can be done as a manual multi-step process, as documented by Rancher [here](http://docs.rancher.com/rancher/quick-start-guide/#create-a-multi-container-application-using-rancher-compose), which will involve manually creating API keys, downloading and installing the Rancher-Compose tool, and exporting the appropriate environment variables to your current terminal session.

### 4. Begin using your new machine!
Your machine is now ready for use.  Below are a couple of important pointers regarding how to use your own projects within the [Hence VM](https://github.com/hence-io/hence), as well as some further suggested reading for those who are unfamiliar with Docker and/or the Rancher framework.

#### Mounting your local files into the VM
Now that you have a fully-functional VM set up, you're going to want to mount your project code from your Host OS (i.e. Mac OSx, Windows) into your VM so that it will be available to the docker containers that will be running it.  There are 2 folders set up in your VM installation location for this:
1. projects: This is where you'll place (or symlink in) your project code.
2. mount: This directory is for mounting any miscellaneous files/folders that you want in the VM, but don't really belong in the project directory.

For projects, we use and recommend a similar file structure as depicted below, though it's entirely up to you how you want to organize your own:

    | machine root
    ├─ projects
    |  ├─ [project-1]
    |  |  ├─ public (put your project code in this folder)
    |  |  ├─ data
    |  |  |  ├─ mysql
    |  |  |  ├─ solr
    |  |  |  └─ etc
    |  |  └─ etc
    |  |
    |  └─ [project-2]
    |     └─ etc
    |
    └─ mount
       └─ [whatever-you-want]

NOTE: Due to performance reasons, we are using rsync to mount local files into the VM over NFS file shares.  This is a one-way sync, and thus, files created by your application will not automatically rsync'ed back down to your local filesystem.

#### Further suggested reading
The Hence.io framework relies heavily on docker containers for all it's project management. If you are unfamiliar with docker, you should start by reading up on at least the following concepts from the Docker Documentation.
1. [About Docker](http://docs.docker.com/misc/)
2. [Docker Compose](http://docs.docker.com/compose/)

On top of Docker, the Hence.io framework uses rancher for docker container/service scheduling and discovery. Rancher, at it's most basic level, provides a UI for building 'Stacks', which are comprised of one or many docker containers that work together to deliver a fully-functioning application.  If you think of a LEMP stack, you might have the following containers working together:
* MariaDb (or MySql)
* PHP
* Nginx (or Apache)

Rancher uses docker-compose.yml files to 'tie' these containers together so that they can communicate with each other.  You will likely end up creating your own docker-compose.yml files for each stack that you use.

It's suggested that you have a good read over the [Rancher Quick Start Guide](http://docs.rancher.com/rancher/quick-start-guide/) for a good understanding of how to use rancher and rancher-compose (or `hence compose`, which is a convenience wrapper around it). Since the rancher server and agents have already been installed for you, you should begin reading at the 'Create a Container through UI' section ([link](http://docs.rancher.com/rancher/quick-start-guide/#create-a-container-through-ui)).

As well, and at the bare minimum, you should also read this quick overview of [rancher concepts](http://docs.rancher.com/rancher/concepts/) that will shed some light on what rancher is doing and is capable of.

## VM Customization
### CLI method (recommended)
If you installed via the [Hence CLI](https://github.com/hence-io/cli), you will set the custom config commands upon installation.  Updates to config will be handled via the [Hence Machine](https://github.com/hence-io/cli/blob/master/docs/machine.md) interface.

### Manual method (again, if you must)
You can override any of the config settings found in `config/default.rb` by creating a `config/custom.rb` file and override any defaults there.

This is the preferred way to customize configurations (for manual installs, that is), so that any future pulls of this repo will not overwrite your custom settings.
