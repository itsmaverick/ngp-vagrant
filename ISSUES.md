Issues found during setup via provided instructions
---
* Vagrant 1.7.2
* There might be no providers coming with default installation. Recovery:
    - Providers are installed as Vagrant plugins
    - Check the list of available plugins using `vagrant plugin list`
    - Install required provider via package manager **OR**
    - Use plugin installation procedure denoted at https://www.vagrantup.com/docs/providers/installation.html
* Used provider `vagrant-libvirt`
    - Not supported by configuration provided
    - After installation of libvirt the service might be unavailable. Restarted via `sudo service libvirtd restart`
