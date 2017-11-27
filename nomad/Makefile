deps:
	cd /vagrant/nomad
	wget -q -nc https://releases.hashicorp.com/nomad/0.6.0/nomad_0.6.0_linux_amd64.zip
	wget -q -nc https://github.com/cbednarski/hostess/releases/download/v0.1.0/hostess_linux_amd64
	apt-get update -qq
	apt-get install -y unzip
	unzip -o nomad_0.6.0_linux_amd64.zip

install:
	cd /vagrant/nomad
	# Install hostess so we can edit the hosts file
	cp hostess_linux_amd64 /usr/local/bin/hostess
	chmod +x /usr/local/bin/hostess

	# Get IP address of the current machine from eth1
	ifconfig eth1 | grep "inet addr" | awk 'BEGIN { FS = "[ :]+" }{print $$4}' > /tmp/self.ip
	hostess add consul `cat /tmp/self.ip`

	# Install nomad binaries
	stop nomad || true
	cp /vagrant/nomad/nomad /usr/local/bin/nomad

	# Add nomad configuration
	mkdir -p /etc/nomad

install-server:
	cd /vagrant/nomad
	sed 's/ADDR/'`cat /tmp/self.ip`'/g' /vagrant/nomad/nomad-server.json > /etc/nomad/nomad.json # we also change bind addr due to https://github.com/hashicorp/nomad/issues/186
	# Setup nomad service and start it
	cp /vagrant/nomad/nomad.upstart.conf /etc/init/nomad.conf
	restart nomad || start nomad
	sleep 1

install-client:
	cd /vagrant/nomad
	sed 's/ADDR/'`cat /tmp/self.ip`'/g' /vagrant/nomad/nomad-client.json > /etc/nomad/nomad.json
	# Setup nomad service and start it
	cp /vagrant/nomad/nomad.upstart.conf /etc/init/nomad.conf
	restart nomad || start nomad
	sleep 1
