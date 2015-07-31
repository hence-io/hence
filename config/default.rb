$vm_box = "ubuntu/trusty64"
$vm_box_version = "20150609.0.10"

$number_of_nodes = 1
$vm_memory = 2048
$vm_cpus = 2
$vm_gui = false

$rancher_ui_port = 8080

$vm_name = "hence"
$private_ip_prefix = "172.19.8"
$rancher_server = "rancher-server"

# Enable port forwarding of Docker TCP socket
$expose_docker_tcp=true

# Enable NFS sharing of your home directory ($HOME) to CoreOS
# It will be mounted at the same path in the VM as on the host.
# Example: /Users/foobar -> /Users/foobar
$share_home=false

# Share additional folders to the CoreOS VMs
# For example,
# $shared_folders = {'/path/on/host' => '/path/on/guest', '/home/foo/app' => '/app'}
# or, to map host folders to guest folders of the same name,
# $shared_folders = Hash[*['/home/foo/app1', '/home/foo/app2'].map{|d| [d, d]}.flatten]
$shared_folders = {}

# Enable port forwarding from guest(s) to host machine, syntax is: { 80 => 8080 }, auto correction is enabled by default.
$forwarded_ports = {}
