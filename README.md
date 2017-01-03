NGP Orchestration using vagrant and virtualbox
=================
Vagrant setup to spin up control plane VMS for NGP

Dependencies
----------------
Ensure that the following software is installed

1. [Vagrant](https://www.vagrantup.com/downloads.html) (tested against versions 1.7.2 and 1.8.1, but it's recommended to use the latest upstream version)
2. [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

If you'd like to run guests using [libvirt](https://github.com/vagrant-libvirt/vagrant-libvirt) provider instead, please refer to the [following section](#create-libvirt-managed-instances)


Install the ngp-vagrant package
----------------

```sh
git clone https://github.com/itsmaverick/ngp-vagrant
```

Add your Gateway IP
------------------------
Add your gateway IP address. The default gateway is router created by VirtualBox for VMs:
```sh
sudo ip route add default via 10.0.2.2
```
Change this ip if required in provision/ubuntuhostsetup.sh


Create Virtual BOX instances
------------------------
To create Virtualbox instances , use the following command:
```sh
vagrant up
```
This creates a dev VM, and three host VMS, with right version of docker, git installed, and Docker files are configured appropriately to accept commands from controlplane.

Ensure right NIC interface is selected when prompted for each host.

```sh
==> host2: Available bridged network interfaces:
1) em1
2) vmnet1
5) vmnet8
==> host2: When choosing an interface, it is usually the one that is
==> host2: being used to connect to the internet.
    host2: Which interface should the network bridge to? 1
```


```sh
[sada@sada-1x ngp-vagrant]$ vagrant status
Current machine states:

dev                       running (virtualbox)
host1                     running (virtualbox)
host2                     running (virtualbox)
host3                     running (virtualbox)

```

Create libvirt managed instances
---
Upstream version of Vagrant ships with support for several [providers](https://www.vagrantup.com/docs/providers/). However, some distributions ship Vagrant with no providers or plugins. Since Vagrant providers are represented by plugins you can check their presence by issuing the following command:

```sh
$ vagrant plugin list
```

At this point you have to make sure `vagrant-libvirt` provider is installed by either

* Installing it via package manager
* Using [plugin installation procedure](https://www.vagrantup.com/docs/plugins/usage.html#installation)

With the first option your package manager will usually install most if not all of required dependencies. The second option, however, requires that you install libvirt and QEMU with one or more drivers [by yourself](https://github.com/vagrant-libvirt/vagrant-libvirt#installation).

```sh
$ vagrant box list
ubuntu/trusty64 (virtualbox, 20161214.0.0)
```

In the above example no boxes suitable for running with the libvirt provider are present. Despite the chosen box not supporting the provider it can be converted to a box which does support it using [vagrant-mutate](https://github.com/sciurus/vagrant-mutate#vagrant-mutate) plugin.

Considering you have no boxes on your local storage the following list of commands will provide you with required box:

```sh
# Download virtualbox capable box to you local storage.
$ vagrant box add ubuntu/trusty64
# Convert the downloaded box to be libvirt capable.
$ vagrant mutate --input-provider virtualbox trusty64 libvirt
# Double check the list.
$ vagrant box list
ubuntu/trusty64 (libvirt, 20161214.0.0)
ubuntu/trusty64 (virtualbox, 20161214.0.0)
```

Now you're ready to create libvirt instances:

```sh
vagrant up
```

There are several differences between configuration of VirtualBox and libvirt instances: *synced folders* and *networking*.

Vagrant is trying to create a `/vagrant` synced folder using NFS shares by default. The issue with this approach is that on most tested environments the NFS service was cut out from the virtual network using a firewall. To make it work out of the box the folder synced by default was disabled. If you need this functionality to work you can add a firewall rule to enable external connection to NFS services and enable the synced folder by commenting out the disabling statement.

The second difference is that no public network is created for guests. Instead the [management interface](https://github.com/vagrant-libvirt/vagrant-libvirt#management-network) is used to connect host with guest machines, provide them with route to external network and interconnect guests themselves.

Accessing the hosts
------------------------
Default username and password for these VMS is vagrant:vagrant. VMs can be accessed using the following.

```sh
vagrant ssh host1
ssh vagrant@[host1 ip]
```
Ensure hostname -i returns the ipaddress not some 127.0.0.0 address. if it does fix it by adding the ipaddress in

```sh
/etc/hosts file
10.32.1.109 host1 host1
```

Note down the IPAddresses of host1, host2, host3 eth1 NIC


Dev machine setup
------------------------
Use dev host to download the ngp-controlplane code and invoke the cloud script.

```sh
git clone https://github.com/Infoblox-CTO/ngp-orchestration.git
```

Build the Code
------------------------
run make command in ngp dir

```sh
make
```

Deploy the CP on all hosts
------------------------
run the cloud command to deploy CP on all hosts
cgroup is the folder in which cgroup is installed on the hosts, mostly it is /cgroup or /sys/fs/cgroup
```sh
cloud/cloud --log [string] dc create --space 192.0.0.0/12 -network 192.2.0.0/16 
cloud/cloud --log [string] dc -u [username] -p [password] attach <HOST1 IP> <HOST2 IP> <HOST3 IP>
```
NOTE that you need a credentials to run "cloud dc attach" command.

For EPAM developers: you should change the first command due to conflict with EPAM network
```sh
cloud/cloud --log [string] dc create --space 192.168.0.0/16 --network 192.168.0.0/12 
```

Test Consul
------------------------
run the following commands to test consul

```sh
curl -i http://[Host ip]:8500/v1/catalog/nodes -X GET
```

Test Marathon
------------------------
run the following commands to test if marathon is properly deployed

```sh
curl -i http://[Host1 ip]:8080/v2/info -X POST
```

What did we do untill now ?
------------------------
we installed, 3 servers with CP infrastructure as shown in this image.
![alt tag](https://cloud.githubusercontent.com/assets/16764317/13334929/61891204-dbc3-11e5-811d-497a4d558bbb.png)


Deploy sample application on CP
------------------------
run the following commands to deploy sample applications

```sh
curl -i http://[Host1 ip]:8080/v2/apps -X POST -H 'Content-Type: application/json' -d@/vagrant/ubuntu.json
```

Destroy the setup
------------------------
To destroy deployed resources
```sh
//destroy all hosts
vagrant destroy
//destroy a host
vagrant destroy host1
```
