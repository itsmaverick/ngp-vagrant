Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/trusty64"
    config.vm.network "public_network"

    config.vm.define "dev" do |dev|
        dev.vm.hostname = 'ngpdev'
        dev.vm.provider :virtualbox do |v|
            v.customize ["modifyvm", :id, "--memory", 1024]
            v.customize ["modifyvm", :id, "--name", "ngpdev"]
            v.cpus = 1
        end

        dev.vm.provision "shell" do |s|
            s.path = "provision/devsetup.sh"
        end
    end

    (1..3).each do |i|
        config.vm.define "node-#{i}" do |node|
            node.vm.hostname = "ngpnode-#{i}"
            node.vm.provider :virtualbox do |v|
                v.customize ["modifyvm", :id, "--memory", 2048]
                v.customize ["modifyvm", :id, "--name", "ngpnode-#{i}"]
                v.cpus = 1
            end

            node.vm.provision "shell" do |s|
                s.path = "provision/nodesetup.sh"
            end
        end
    end


end
