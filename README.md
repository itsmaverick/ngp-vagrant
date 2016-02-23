NGP Orchestration using vagrant and virtualbox
=================
Vagrant setup to spin up control plane VMS for NGP 

Dependencies
----------------
Ensure that the following software is installed 
```sh
virtualbox: https://www.virtualbox.org/wiki/Downloads
vagrant:    https://www.vagrantup.com/downloads.html
```

Install the ngp-vagrant package
----------------

```sh
git clone https://github.com/itsmaverick/ngp-vagrant
```

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

Accessing the hosts
------------------------
Default username and password for these VMS is vagrant:vagrant. VMs can be accessed using the following.

```sh
[sada@sada-1x ngp-vagrant]$ vagrant ssh host1
[sada@sada-1x ngp-vagrant]$ ssh vagrant@[host1 ip]
```
Note down the IPAddresses of host1, host2, host3 eth1 NIC

```sh
vagrant@host1:~$ ifconfig eth1 | grep "inet addr"
          inet addr:10.32.1.25  Bcast:10.32.255.255  Mask:255.255.0.0
```

Dev machine setup
------------------------
Use dev host to download the ngp-controlplane code and invoke the cloud script.

```sh
vagrant@dev:~$ git clone https://github.com/Infoblox-CTO/ngp-orchestration.git
```

Build the Code
------------------------
run make command in ngp dir

```sh
vagrant@dev:~/ngp-orchestration$ make
```

Deploy the CP on all hosts
------------------------
run the cloud command to deploy CP on all hosts

```sh
cloud/cloud -log docker create <HOST IP 1> <HOST IP 2> <HOST IP 3> ...
```

Test Consul
------------------------
run the following commands to test consul

```sh
vagrant@dev:~/ngp-orchestration$ curl -i http://[Host ip]:8500/v1/catalog/nodes -X GET
``

Test Marathon
------------------------
run the following commands to create sample applications

```sh
vagrant@dev:~/ngp-orchestration$ curl -i http://[Host1 ip]:8080/v2/apps -X POST -H 'Content-Type: application/json' -d@/vagrant/ubuntu.json
``
To destroy deployed AWS resources
```sh
vagrant destroy
```
