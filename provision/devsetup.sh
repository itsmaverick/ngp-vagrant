#!/bin/bash

echo "Provisioning virtual machine..."

echo "Installing Docker"
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
# edit your /etc/apt/sources.list.d/docker.list
# Ubuntu Trusty 
echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list

apt-get update
apt-get install docker-engine -y > /dev/null
usermod -aG docker vagrant
systemctl enable docker

# Git
echo "Installing Git"
apt-get install git -y > /dev/null
#git clone https://github.com/Infoblox-CTO/ngp-orchestration.git

echo "Finished provisioning."
