# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "puphpet/ubuntu1404-x64"

  config.vm.define "consul" do |c|
    c.vm.hostname = "consul"
    c.vm.network "private_network", ip: "172.20.20.10"
    c.vm.provision "shell", path: "consul/install.sh", privileged: false
    c.vm.provision "file", source: "consul/consul-server.json", destination: "/etc/consul.d/consul.json"
    c.vm.provision "shell", inline: "consul agent -config-dir /etc/consul.d &"
    config.vm.provider "virtualbox" do |v|
      v.memory = 256
      v.cpus = 1
    end
  end

  config.vm.define "nomad" do |n|
    n.vm.hostname = "nomad"
    n.vm.network "private_network", ip: "172.20.20.5"
    n.vm.provision "shell", path: "nomad/server.sh", privileged: false
    n.vm.provision "shell", path: "consul/install.sh", privileged: false
    n.vm.provision "file", source: "consul/consul-agent.json", destination: "/etc/consul.d/consul.json"
    n.vm.provision "shell", inline: "consul agent -config-dir /etc/consul.d &"
    n.vm.provision "docker" # Just install it
    config.vm.provider "virtualbox" do |v|
      v.memory = 256
      v.cpus = 1
    end
  end

  (1..3).each do |d|
    config.vm.define "docker#{d}" do |node|
      node.vm.hostname = "docker#{d}"
      node.vm.network "private_network", ip: "172.20.20.2#{d}"
      node.vm.provision "shell", path: "nomad/agent.sh", privileged: false
      node.vm.provision "shell", path: "consul/install.sh", privileged: false
      node.vm.provision "file", source: "consul/consul-agent.json", destination: "/etc/consul.d/consul.json"
      node.vm.provision "shell", inline: "consul agent -config-dir /etc/consul.d &"
      node.vm.provision "docker" # Just install it
      config.vm.provider "virtualbox" do |v|
        v.memory = 512
        v.cpus = 1
      end
    end
  end

end

