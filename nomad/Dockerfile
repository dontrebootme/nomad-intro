FROM debian:8
MAINTAINER "Patrick O'Connor"

RUN apt-get update && apt-get install -y ca-certificates unzip curl

EXPOSE :4646
EXPOSE :4647
EXPOSE :4648

# Get nomad
RUN cd /tmp && \
    curl -sSL https://releases.hashicorp.com/nomad/0.2.1/nomad_0.2.1_linux_amd64.zip -o nomad.zip && \
    unzip nomad.zip && \
    chmod +x nomad && \
    mv nomad /usr/bin/nomad && \
    mkdir -p /etc/nomad.d && \
    chmod a+w /etc/nomad.d

ENTRYPOINT ["/usr/bin/nomad"]
