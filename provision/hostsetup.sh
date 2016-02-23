#!/bin/bash

echo "Provisioning virtual machine..."

echo "Installing Docker"
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
# edit your /etc/apt/sources.list.d/docker.list
# Ubuntu Trusty 
echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list

apt-get update
apt-get install docker-engine -y > /dev/null

echo 'DOCKER_OPTS="-H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock"' > /etc/default/docker
usermod -aG docker vagrant
service docker restart
echo "Finished provisioning."
