# -*- mode: ruby -*-
# vi: set ft=ruby :

$nomad_script = <<SCRIPT
# Update apt and get dependencies
sudo apt-get update
sudo apt-get install -y unzip curl wget vim

# Download Nomad
echo Fetching Nomad...
cd /tmp/
curl -sSL https://releases.hashicorp.com/nomad/0.2.1/nomad_0.2.1_linux_amd64.zip -o nomad.zip

echo Installing Nomad...
unzip nomad.zip
sudo chmod +x nomad
sudo mv nomad /usr/bin/nomad

sudo mkdir -p /etc/nomad.d
sudo chmod a+w /etc/nomad.d

SCRIPT

$consul_script = <<SCRIPT

echo Installing dependencies...
sudo apt-get update
sudo apt-get install -y unzip curl

echo Fetching Consul...
cd /tmp/
wget https://dl.bintray.com/mitchellh/consul/0.5.2_linux_amd64.zip -O consul.zip

echo Installing Consul...
unzip consul.zip
sudo chmod +x consul
sudo mv consul /usr/bin/consul

sudo mkdir /etc/consul.d
sudo chmod a+w /etc/consul.d

SCRIPT

Vagrant.configure(2) do |config|
  config.vm.box = "puphpet/ubuntu1404-x64"
  config.vm.hostname = "nomad"
  config.vm.provision "shell", inline: $nomad_script, privileged: false
  config.vm.provision "docker" # Just install it

  # Increase memory for Virtualbox
  config.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
  end

  config.vm.provision "shell", inline: $consul_script

  config.vm.define "consul1" do |c1|
      c1.vm.hostname = "consul1"
      c1.vm.network "private_network", ip: "172.20.20.10"
  end

  config.vm.define "consul2" do |c2|
      c2.vm.hostname = "consul2"
      c2.vm.network "private_network", ip: "172.20.20.11"
  end

end

