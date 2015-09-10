VAGRANTFILE_API_VERSION = "2"
Vagrant.require_version ">=1.7.2"

unless Vagrant.has_plugin?("vagrant-bindfs")
  raise 'vagrant-bindfs is not installed!  Please run `vagrant plugin install vagrant-bindfs`'
end

unless Vagrant.has_plugin?("vagrant-vbguest")
  puts 'Plugin vagrant-vbguest is not installed!  For ideal virtualbox performance, it is strongly recommended that you install it by running `vagrant plugin install vagrant-vbguest`.'
end

unless Vagrant.has_plugin?("vagrant-gatling-rsync")
  puts 'Plugin vagrant-gatling-rsync is not installed!  For performance reasons, it is strongly recommended that you install it by running `vagrant plugin install vagrant-gatling-rsync`.'
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    $provision_timestamp = Time.now.to_i

    # --------------------------------------------------
    # Box Config
    # --------------------------------------------------

    # Load default vagrant config options
    require_relative 'config/default'

    # To update any of the above default options, add a custom.rb file that overrides any default values (found in 'default.rb') as required
    # --------------------------------------------------
    # EXAMPLE contents for custom.rb:
    # $rancher_ui_port = 3000
    # $vb_memory = 1024
    # $vb_cpus = 1
    # $rsync_folder_disabled = false
    # --------------------------------------------------

    CUSTOM_CONFIG = File.join(File.dirname(__FILE__), "config", "custom.rb")

    if File.exist?(CUSTOM_CONFIG)
        require CUSTOM_CONFIG
    end


    # --------------------------------------------------
    # Box Setup
    # --------------------------------------------------
    config.vm.box = $vm_box || "ubuntu/trusty64"
    config.vm.box_version = $vm_box_version || "20150609.0.10"

    if $vm_box == "rancherio/rancheros"
        config.vm.box_version = ">=0.3.3"
        require_relative 'vagrant_rancheros_guest_plugin.rb'

        config.vm.provider :virtualbox do |v|
            # On VirtualBox, we don't have guest additions or a functional vboxsf
            # in RancherOS, so tell Vagrant that so it can be smarter.
            v.check_guest_additions = false
            v.functional_vboxsf     = false
        end

        # plugin conflict
        if Vagrant.has_plugin?("vagrant-vbguest") then
            config.vbguest.auto_update = false
        end
    end

    # Disable synching current directory
    config.vm.synced_folder "./", "/vagrant", disabled: true

    server_ip = "#{$private_ip_prefix}.#{$private_ip_end}"

    # Set up the nodes
    (1..$number_of_nodes).each do |i|
        is_base_host = (i == 1)
        hostname = is_base_host ? $vm_name : "#{$vm_name}-%01d" % i

        config.vm.define hostname do |node|
            node.vm.provider :virtualbox do |v|
                v.name = hostname
                v.memory = $vm_memory || 2048
                v.cpus = $vm_cpus || 2
                v.customize ["modifyvm", :id, "--ioapic", "on"]

                # Set $vm_gui to `true` to enable gui mode so that you can choose to boot normally after an improper shutdown. This may help in the case of connection timeout errors:
                v.gui = $vm_gui || false
            end

            node.vm.hostname = hostname

            node_ip = "#{$private_ip_prefix}.#{i+($private_ip_end - 1)}"
            node.vm.network "private_network", ip: node_ip
            node.ssh.forward_agent = true

            # --------------------------------------------------
            # Port Forwarding
            # --------------------------------------------------
            if is_base_host then
                # Forward rancher_ui port
                node.vm.network "forwarded_port", guest: 8080, host: $rancher_ui_port, auto_correct: true
            end

            # Forward the docker daemon tcp.  Defaults to 2375.  Set to false in custom.rb to disable
            if $expose_docker_tcp
                node.vm.network "forwarded_port", guest: 2375, host: 2375, auto_correct: true
            end

            # Add any custom-configured exposed ports
            $forwarded_ports.each do |guest, host|
                node.vm.network "forwarded_port", guest: guest, host: host, auto_correct: true
            end

            # --------------------------------------------------
            # Folder Mounting
            # --------------------------------------------------

            # Configure the window for gatling to coalesce writes.
            if Vagrant.has_plugin?("vagrant-gatling-rsync")
                config.gatling.latency = $gatling_rsync_latency
                config.gatling.time_format = "%H:%M:%S"

                # Automatically sync when machines with rsync folders come up.
                config.gatling.rsync_on_startup = $gatling_rsync_on_startup
            end


            node.vm.synced_folder "./projects", "/hence/projects", id: "projects", type: "rsync", rsync__exclude: $rsync_exclude, rsync__args: $rsync_project_args

            node.vm.synced_folder "./mount", "/vagrant-nfs/mount", id: "mount", type: "nfs", :nfs_version => "3", :mount_options => ["actimeo=2"]
            config.bindfs.bind_folder "/vagrant-nfs/mount", "/hence/mount", :owner => "vagrant", :group => "vagrant", :'create-as-user' => true, :perms => "u=rwx:g=rwx:o=rwx", :'create-with-perms' => "u=rwx:g=rwx:o=rwx", :'chown-ignore' => true, :'chgrp-ignore' => true, :'chmod-ignore' => true

            # Optionally, mount the User's home directory in the VM.  Defaults to false.
            if $share_home
                node.vm.synced_folder ENV['HOME'], ENV['HOME'], id: "home", type: "rsync", rsync__exclude: $rsync_exclude, rsync__args: $rsync_mount_args
            end

            # Optionally, mount arbitrary folders to the vm
            $shared_folders.each_with_index do |(host_folder, guest_folder), index|
                node.vm.synced_folder host_folder.to_s, guest_folder.to_s, id: "rancher-share%02d" % index, type: "rsync", rsync__exclude: $rsync_exclude, rsync__args: $rsync_mount_args
            end

            # --------------------------------------------------
            # Node Provisioning
            # --------------------------------------------------

            # Fix for tty warnings while provisioning ubuntu. See: http://foo-o-rama.com/vagrant--stdin-is-not-a-tty--fix.html
            config.vm.provision "fix-no-tty", type: "shell" do |s|
                s.privileged = false
                s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
            end

            config.vm.provision :shell, path: "./scripts/setup/prepare.sh", :privileged => true

            # config.vm.provision :shell, path: "./scripts/setup/remove-swap.sh", :privileged => true
            config.vm.provision :shell, path: "./scripts/setup/create-swap.sh", :privileged => true

            config.vm.provision :shell, path: "./scripts/setup/prepare-docker-install.sh", :privileged => true
            config.vm.provision :shell, :inline => "[ -f /etc/default/docker.#{$docker_version}.installed ] || apt-get update && apt-get install -y docker-engine=#{$docker_version} && touch /etc/default/docker.#{$docker_version}.installed", :privileged => true

            config.vm.provision :shell, path: "./scripts/setup/configure-docker.sh", :privileged => true

            config.vm.provision :shell, path: "./scripts/setup/configure-folder-permissions.sh", :privileged => true

            $rancher_server_image = "rancher/server:#{$rancher_server_version}"
            $rancher_agent_image = "rancher/agent:#{$rancher_agent_version}"

            # Remove any crashed containers on provision
            $container_cleanup_starting = 'echo "INFO: Cleaning up any failed containers"'
            $container_cleanup_success = 'echo "INFO: Cleanup complete"'
            $container_cleanup_script = "#{$container_cleanup_starting} && crashed=`docker ps -aq -f exited=1`; [ -z \"$crashed\" ] || docker rm -f $crashed; #{$container_cleanup_success}"
            config.vm.provision :shell, :inline => $container_cleanup_script, :privileged => true

            if is_base_host then
                config.vm.provision "docker" do |d|
                    d.run $rancher_server_image,
                        auto_assign_name: false,
                        daemonize: true,
                        restart: 'always',
                        args: "-p 8080:8080 --name rancher-server"
                end
            end

            config.vm.provision "docker" do |d|
                d.run $rancher_agent_image,
                    auto_assign_name: false,
                    daemonize: false,
                    restart: 'no',
                    args: "-e CATTLE_AGENT_IP=#{node_ip} -e WAIT=true -v /var/run/docker.sock:/var/run/docker.sock --name rancher-agent-init",
                    cmd: "http://#{server_ip}:8080"
            end

            config.vm.provision :shell, :inline => "docker logs -f --since #{$provision_timestamp} rancher-agent-init", :privileged => true
            config.vm.provision :shell, :inline => "docker logs -f --since #{$provision_timestamp} rancher-agent", :privileged => true
        end
    end
end
