# Introduction to Nomad

## Introducing cluster schedulers
Fleet, Kubernetes, Mesos, Nomad, Rancher, and Swarm. These are probably some names you've heard if you've read any container news recently. These tools often try to solve the scheduling, placement and supervision of containers (and other tasks) across multiple hosts, maintaining service health and removing the need to manually place your services on specific hosts. Cluster schedulers provides benefits:
* Treat hosts as cattle, not pets. Hosts become a collection of resources (CPU/Memory etc) and not snowflakes.
* Service supervision. If a service's health check fails, the scheduler can automatically respawn it, even on another host.
* Handle host failure. If our request of the scheduler is to ensure 20 instances of a service are running, that request is fulfilled even if a host dies. We simply reschedule the failed services on other hosts.
* Scale up/down functionality. Scale a service is as simple as updating an instance count in the cluster scheduler.
* System that can be queried to know where services are running and the state of those services. This can be used to configure load balancers and other services.

So we see some benefits of having a cluster scheduler to handle the deployment, description, health, and scaling of our containerized services, but to run some of these schedulers requires a long list of dependencies. Enter Hashicorp's Nomad, from the team that brought you [Atlas](https://atlas.hashicorp.com/), [Consul](https://www.consul.io/), [Vagrant](https://www.vagrantup.com/), [Packer](https://www.packer.io/), [Serf](https://serfdom.io/), [Terraform](https://terraform.io/), [Vault](https://www.vaultproject.io/), and recently [Otto](https://ottoproject.io/). Nomad is a go binary making it simple to deploy and get started with, without bringing understanding of other systems into the mix.

## Understanding Nomad
Nomad is built to be operationally simple. Let's spin up a local nomad cluster and dive into the different components and how we can use Nomad hands on.

### Spin up local cluster
We are going to leverage Vagrant to build out multiple machines that we can use to demonstrate container scheduling with Nomad. These machines will be one of three roles:
* Nomad server (1)
* Consul server (1)
* Docker host (3)

To get started, perform a git clone on [nomad-intro](https://github.com/dontrebootme/nomad-intro). Make sure you have Vagrant installed.

```
git clone https://github.com/dontrebootme/nomad-intro
cd nomad-intro
vagrant up
```

This process starts and configures a nomad host using `nomad/install.sh`, a consul host using `consul/install.sh` and three docker hosts using `docker/install.sh`

### Nomad server
A nomad agent in server mode acts as the manager for the agents and applications in your cluster. A normal production cluster would have multiple Nomad agents acting in server mode, in this demo we are using only one. We describe how we want Nomad to run our applications by defining jobs. I've included a sample job with a task that launches a web server in the [nomad-intro](https://github.com/dontrebootme/nomad-intro) repository. The `.nomad` file mainly defines job, task group and task. A job file will only ever describe a single job, but can have multiple tasks. Additional definitions in the job definition include data such as datacenter, region, instance count, update policy, resources allocated, networking speed, port allocations and health checks.

To demonstrate how we schedule a job with Nomad, send the provided job definition to your nomad server via:
```
steps here
```

Nomad will recieve the job definition and act on that request by scheduling the tasks on the [agent nodes](#agents).

### <a name="agents"></a> Nomad Agent
Nomad agents will receive requests for tasks from the Nomad server and if possible, act on those requests. In our example above, we asked Nomad to find matches 50 instances of microbot tasks which in this example are webservers running in a docker container as defined by the job definition above. We will ask Nomad to allocate ports for the containers we launch and monitor the health of those services to act on them should the health check ever fail.

### Consul
Consul is typically seen as two components, service discovery and distributed key value storage. We will focus on the service discovery portion of Consul for an automated way to discover and query our servers that may exist around our environment. Consul and Nomad work well together in the regard that we can have Nomad inform Consul of all running services, their host and port, and the health of those services.

With Nomad and Consul in sync, we can automate other systems such as our load balancer to automatically update when we move our services around or when we scale our services.

### Further experimentation:
Now that we've covered Nomad server, Nomad agent, and how we can leverage Consul for service discovery, lets do some further demonstrations of interacting with Nomad for tasks such as:
* Scale up our microbot service
* Updating our service with an automated rolling upgrade
* Deploying a container metrics collection tool using Nomad system jobs
* Query consul for all running instances of our updated and scaled microbot service.

## Spin down and clean up
When you're done, you can shut down the cluster using

```
$ vagrant halt
```

And free up some disk space using

```
$ vagrant destroy -f
```

If you want to change any of the configuration/scripts run

```
$ vagrant provision
```

## Conclusion
In conclusion, there are numerous options for container cluster schedulers, Nomad's angle seems an operationally simple solution with less infrastructure needs. We've learned how we can leverage Nomad to distribute a task around multiple hosts, scale those tasks, and deploy updates with ease while letting the cluster scheduler handle the placement, supervision and rolling updates of our service.
