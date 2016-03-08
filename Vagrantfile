NUM_HOSTS   = 3
HOST_RAM    = 2048

Vagrant.configure("2") do |config|
    config.vm.network "public_network"

    (1..NUM_HOSTS).each do |i|
        config.vm.define "host#{i}" do |host|
            host.vm.box = "ubuntu/trusty64"
            host.vm.hostname = "host#{i}"
            host.vm.provider :virtualbox do |v|
                v.customize ["modifyvm", :id, "--memory", HOST_RAM]
                v.customize ["modifyvm", :id, "--name", "host#{i}"]
                v.cpus = 1
            end

            host.vm.provision "shell" do |s|
                s.path = "provision/ubuntuhostsetup.sh"
            end
        end
    end


end
