#!/bin/bash

echo "Provisioning virtual machine..."

echo "Installing Docker"
sudo yum update -y
sudo curl -fsSL https://get.docker.com/ | sh
sudo usermod -aG docker vagrant
sudo systemctl enable docker
sudo chkconfig docker on
sudo service docker restart
# Git
echo "Installing Git"
sudo yum install git -y > /dev/null
#git clone https://github.com/Infoblox-CTO/ngp-orchestration.git

echo "Finished provisioning."
