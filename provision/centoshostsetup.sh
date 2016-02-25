#!/bin/bash

echo "Provisioning virtual machine..."

echo "Installing Docker"
sudo yum update -y
sudo curl -fsSL https://get.docker.com/ | sh
sudo usermod -aG docker vagrant
sudo systemctl enable docker
sudo chkconfig docker on
sudo service docker restart
echo "Finished provisioning."
