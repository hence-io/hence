$vm_box = "ubuntu/trusty64"
$vm_box_version = "20150609.0.10"

$number_of_nodes = 1
$vm_memory = 2048
$vm_cpus = 2
$vm_gui = false

$rancher_ui_port = 8080
$rancher_server_version = "v1.0.1"
$rancher_agent_version = "v1.0.1"

$vm_name = "hence"

$private_ip_prefix = "172.19.8"
$private_ip_end = 100

$rancher_server = "rancher-server"

# Enable port forwarding of Docker TCP socket
$expose_docker_tcp = true
$docker_version = "1.9.1-0~trusty"

# Gatling rsync latency.  This will prevent rsync from firing until <value> contiguous secons without file events have passed.
# This will delay rsyncs from happening if many writes are happening on the host (during a make or a git clone, for example) until the activity has leveled off.
$gatling_rsync_latency = 1
$gatling_rsync_on_startup = false

# Enable NFS sharing of your home directory ($HOME) to CoreOS
# It will be mounted at the same path in the VM as on the host.
# Example: /Users/foobar -> /Users/foobar
$share_home = false

# Rsync folder options
$rsync_mount_args = ["-rtlDPvc", "--delete"]
$rsync_project_args = ["-rtlDPvc", "--safe-links"]
$rsync_exclude = [".git"]

# Share additional folders to the CoreOS VMs
# For example,
# $shared_folders = {'/path/on/host' => '/path/on/guest', '/home/foo/app' => '/app'}
# or, to map host folders to guest folders of the same name,
# $shared_folders = Hash[*['/home/foo/app1', '/home/foo/app2'].map{|d| [d, d]}.flatten]
$shared_folders = {}

# Enable port forwarding from guest(s) to host machine, syntax is: { 80 => 8080 }, auto correction is enabled by default.
$forwarded_ports = {}

# Whether or not to mount to all nodes in a multinode setup
$mount_folders_on_all_nodes = false
