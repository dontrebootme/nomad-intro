# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "puphpet/ubuntu1404-x64"


  config.vm.define "nomad" do |n|
    n.vm.hostname = "nomad"
    n.vm.provision "shell", path: "nomad/server.sh", privileged: false
    n.vm.provision "docker" # Just install it
  end

  config.vm.define "consul" do |c|
    c.vm.hostname = "consul1"
    c.vm.network "private_network", ip: "172.20.20.10"
    c.vm.provision "shell", path: "consul/install.sh", privileged: false
    c.vm.provision "file", source: "consul/consul.json", destination: "/etc/consul.d/"
    c.vm.provision "shell", inline: "consul agent -config-dir /etc/consul.d"
  end


  (1..3).each do |d|
    config.vm.define "docker#{d}" do |node|
      node.vm.hostname = "docker#{d}"
      node.vm.network "private_network", ip: "172.20.20.2#{d}"
      node.vm.provision "shell", path: "nomad/agent.sh", privileged: false
      node.vm.provision "docker" # Just install it
    end
  end

end

