#!/bin/bash

echo "Provisioning virtual machine..."
echo "adding gateway..."
sudo route del -net 0.0.0.0 
# santa clara your gw is 10.32.0.1, canada:172.31.1.1 add your gateway ip here
sudo route add -net 0.0.0.0 gw <changeme>  dev eth1

echo "Installing Docker"
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
# edit your /etc/apt/sources.list.d/docker.list
# Ubuntu Trusty 
sudo echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list

sudo apt-get update
sudo apt-get install docker-engine -y > /dev/null
sudo groupadd docker
sudo rm -rf /etc/default/docker
sudo echo 'DOCKER_OPTS="-H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock"' > /etc/default/docker
sudo usermod -aG docker vagrant
sudo service docker restart
echo "Configuring /etc/hosts"
new_ip=$(ip address show eth1 | grep 'inet ' | sed -e 's/^.*inet //' -e 's/\/.*$//')
name=$(hostname)
echo "$new_ip $name $name" 
sed "10 c\
$new_ip $name $name" /etc/hosts > a
sudo mv a /etc/hosts
#sudo echo "$new_ip $name $name" >> /etc/hosts
echo "Finished provisioning."

