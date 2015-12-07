# Introduction to Nomad

## Introducing cluster schedulers
Fleet, Kubernetes, Mesos, Nomad, Rancher, and Swarm. These are probably some names you've heard if you've read any container news recently. These tools often try to solve the scheduling, placement and supervision of containers (and other tasks) across multiple hosts, maintaining service health and removing the need to manually place your services on specific hosts. Cluster schedulers provides benefits:
* Treat hosts as cattle, not pets. Hosts become a collection of resources (CPU/Memory etc) and not snowflakes.
* Service supervision. If a service's health check fails, the scheduler can automatically respawn it, even on another host.
* Handle host failure. If our request of the scheduler is to ensure 20 instances of a service are running, that request is fulfilled even if a host dies. We simply reschedule the failed services on other hosts.
* Scale up/down functionality. Scale a service is as simple as updating an instance count in the cluster scheduler.
* System that can be queried to know where services are running and the state of those services. This can be used to configure load balancers and other services.

So we see some benefits of having a cluster scheduler to handle the deployment, description, health, and scaling of our containerized services, but to run some of these schedulers requires a long list of dependencies. Enter Hashicorp's Nomad, from the team that brought you [Atlas](https://atlas.hashicorp.com/), [Consul](https://www.consul.io/), [Vagrant](https://www.vagrantup.com/), [Packer](https://www.packer.io/), [Serf](https://serfdom.io/), [Terraform](https://terraform.io/), [Vault](https://www.vaultproject.io/), and recently [Otto](https://ottoproject.io/).

 ### Introduction
 ###
