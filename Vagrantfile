NUM_HOSTS   = 3
HOST_RAM    = 2048

Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/trusty64"

    config.vm.provider :virtualbox do
        config.vm.network "public_network"
    end
    config.vm.provider :libvirt do
        config.vm.synced_folder ".", "/vagrant", type: "rsync"
    end

    config.vm.define "dev" do |dev|
        dev.vm.hostname = 'dev'
        dev.vm.provider :virtualbox do |v|
            v.customize ["modifyvm", :id, "--memory", HOST_RAM]
            v.customize ["modifyvm", :id, "--name", "dev"]
            v.cpus = 1
        end
        dev.vm.provider :libvirt do |domain|
            domain.memory = HOST_RAM
            domain.cpus = 1
        end
        dev.vm.provision "shell" do |s|
            s.path = "provision/ubuntuhostsetup.sh"
        end
    end

    (1..NUM_HOSTS).each do |i|
        config.vm.define "host#{i}" do |host|
            host.vm.box = "ubuntu/trusty64"
            host.vm.hostname = "host#{i}"
            host.vm.provider :virtualbox do |v|
                v.customize ["modifyvm", :id, "--memory", HOST_RAM]
                v.customize ["modifyvm", :id, "--name", "host#{i}"]
                v.cpus = 1
            end
            host.vm.provider :libvirt do |domain|
                domain.memory = HOST_RAM
                domain.cpus = 1
            end
            host.vm.provision "shell" do |s|
                s.path = "provision/ubuntuhostsetup.sh"
            end
        end
    end
end
