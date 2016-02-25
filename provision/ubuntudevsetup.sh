#!/bin/bash

echo "Provisioning virtual machine..."

echo "Installing Docker"
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
# edit your /etc/apt/sources.list.d/docker.list
# Ubuntu Trusty 
sudo echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list

sudo apt-get update
sudo apt-get install docker-engine -y > /dev/null
sudo groupadd docker
sudo usermod -aG docker vagrant
sudo systemctl enable docker


echo "Configuring /etc/hosts"
new_ip=$(ip address show eth1 | grep 'inet ' | sed -e 's/^.*inet //' -e 's/\/.*$//')
name=$(hostname)
echo "$new_ip $name $name" 
sudo echo "$new_ip $name $name" >> /etc/hosts

sudo echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list
# Git
echo "Installing Git"
sudo apt-get install git -y > /dev/null
#git clone https://github.com/Infoblox-CTO/ngp-orchestration.git

echo "Finished provisioning."