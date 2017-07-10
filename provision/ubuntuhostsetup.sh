#!/bin/bash

# We need to rename some interfaces due to conflict between vagrant and CP (vagrant
# creates NAT interface for access Internet through eth0 and CP is trying to use
# eth0 for connection between nodes)
sudo ip link set dev eth0 down && ip link set eth0 name eth00 && ip link set dev eth00 up
sudo ip link set dev eth1 down && ip link set eth1 name eth0 && ip link set dev eth0 up
sudo ip link set dev eth00 down && ip link set eth00 name eth1 && ip link set dev eth1 up

# We need to turn off ipv6 due to issues with it in VMs
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1

echo "Provisioning virtual machine..."
#echo "adding gateway..."
#sudo route del -net 0.0.0.0 
# santa clara your gw is 10.32.0.1, canada:172.31.1.1 add your gateway ip here
#sudo route add -net 0.0.0.0 gw 10.32.0.1  dev eth1
# 10.0.2.2 - router created by VirtualBox for VMs. You should check this.
sudo ip route add default via 10.0.2.2

echo "Installing Docker"
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
# edit your /etc/apt/sources.list.d/docker.list
# Ubuntu Trusty 
sudo echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list

# This command is actual for Belarus. Please comment it if you are going to use original repo
sudo sed -i 's/archive.ubuntu.com/by.archive.ubuntu.com/g' /etc/apt/sources.list
sudo apt-get update
# We need to install docker-engine v.1.13.1-0~ubuntu-trusty instead of previos 1.9.1-0~trusty
sudo apt-get install docker-engine=1.13.1-0~ubuntu-trusty -y > /dev/null


sudo groupadd docker
sudo cp -rf /vagrant/docker.cfg /etc/default/docker

sudo usermod -aG docker vagrant
sudo service docker restart
echo "Configuring /etc/hosts"
# CP uses eth0 interface, so new_ip should be taken from eth0
new_ip=$(ip address show eth0 | grep 'inet ' | sed -e 's/^.*inet //' -e 's/\/.*$//')
name=$(hostname)
echo "$new_ip $name $name" 
# It's better to change /etc/hosts in the following manner instead of previous one
echo "$new_ip $name $name
127.0.0.1 localhost">a
sudo mv a /etc/hosts
#sed "10 c\
#$new_ip $name $name" /etc/hosts > a
#sudo mv a /etc/hosts

# Git
#echo "Installing Git"
#sudo apt-get install git -y > /dev/null

echo "Finished provisioning."

