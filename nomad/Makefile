deps:
	cd /vagrant/nomad
	wget -q -nc https://releases.hashicorp.com/nomad/0.2.1/nomad_0.2.1_linux_amd64.zip
	wget -q -nc https://github.com/cbednarski/hostess/releases/download/v0.1.0/hostess_linux_amd64
	apt-get update -qq
	apt-get install -y unzip
	unzip -o nomad_0.2.1_linux_amd64.zip

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

	# Setup consul service and start it
	cp /vagrant/nomad/nomad.upstart.conf /etc/init/nomad.conf
	restart nomad || start nomad
	sleep 1

install-server:
	echo "Nomad Server"

install-agent:
	echo "Nomad Agent"

