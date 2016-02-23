NUM_HOSTS   = 3
DEV_RAM     = 1024
HOST_RAM    = 2048
PUB_NET     = "em1"

Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/trusty64"
    config.vm.network "public_network", :public_network => "em1"

    config.vm.define "dev" do |dev|
        dev.vm.hostname = 'dev'
        dev.vm.provider :virtualbox do |v|
            v.customize ["modifyvm", :id, "--memory", DEV_RAM]
            v.customize ["modifyvm", :id, "--name", "dev"]
            v.cpus = 1
        end

        dev.vm.provision "shell" do |s|
            s.path = "provision/devsetup.sh"
        end
    end

    (1..NUM_HOSTS).each do |i|
        config.vm.define "host#{i}" do |host|
            host.vm.hostname = "host#{i}"
            host.vm.provider :virtualbox do |v|
                v.customize ["modifyvm", :id, "--memory", HOST_RAM]
                v.customize ["modifyvm", :id, "--name", "host#{i}"]
                v.cpus = 1
            end

            host.vm.provision "shell" do |s|
                s.path = "provision/hostsetup.sh"
            end
        end
    end


end
