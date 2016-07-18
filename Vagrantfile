# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure(2) do |config|
  5.times do |num|
    config.vm.define "habitat_node_#{num}" do |node|
      config.vm.synced_folder "~/src", "/home/vagrant/src"

      node.vm.box = "ubuntu/trusty64"
      node.vm.hostname = "habitat-node-#{num}"
      node.vm.network :private_network, ip: "192.168.33.1#{num}"

      node.vm.provider "virtualbox" do |vb|
        vb.name = "habitat_node_#{num}"
        vb.cpus = 2
        vb.memory = 1024
        vb.customize ["modifyvm", :id, "--nic2","natnetwork"]
        vb.customize ["modifyvm", :id, "--nictype2","82540EM"]
        vb.customize ["modifyvm", :id, "--nicpromisc2","allow-all"]  
        vb.customize ["modifyvm", :id, "--nat-network2", "habitat_network"]
      end

      node.vm.provision "shell", path: "provision.sh", privileged: false
      node.vm.provision "shell", run: "always", inline: "route add default gw 192.168.33.1"
      node.vm.provision "shell", run: "always", inline: "route del default gw 10.0.2.2"
    end
  end
end
