#!/bin/bash
echo Installing dependencies...
sudo apt-get update 2>&1 > /dev/null
sudo apt-get install -y unzip curl 2>&1 > /dev/null

echo Fetching Consul...
cd /tmp/
curl -sSL https://releases.hashicorp.com/consul/0.6.0/consul_0.6.0_linux_amd64.zip -o consul.zip

echo Installing Consul...
unzip -o consul.zip 2>&1 > /dev/null
sudo chmod +x consul
sudo mv consul /usr/bin/consul

echo Fetching Consul UI...
curl -sSL https://releases.hashicorp.com/consul/0.6.0/consul_0.6.0_web_ui.zip -o consul_ui.zip

echo Installing Consul Ui...
if [ ! -d /opt/consul-ui ]; then sudo mkdir /opt/consul-ui; fi
sudo chmod a+w /opt/consul-ui
unzip -o consul_ui.zip -d /opt/consul-ui 2>&1 > /dev/null

if [ ! -d /etc/consul.d ]; then sudo mkdir /etc/consul.d; fi
sudo chmod a+w /etc/consul.d

if [ -d /var/lib/consul ]; then sudo rm -rf /var/lib/consul; fi
