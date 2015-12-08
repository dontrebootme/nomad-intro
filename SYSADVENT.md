# Introduction to Nomad

## Introducing cluster schedulers
Are you still running all of your containers with a single DOCKER_HOST? Have you managed to spread the load between two or three hosts but manually run `docker run` commands on each host to bootstrap your container infrastructure? If so, you should consider useng a container scheduler instead.
Fleet, Kubernetes, Mesos, Nomad, Rancher, and Swarm are probably some names you've heard of if you've read any container news recently. Schedulers provide many benefits in a containerized environment. They are the next big step once you've played with a local development environment or when you are finally going to deploy your CI/CD pipeline. Container schedulers vary in their features and implementation but some of the core principles are the same.

* *Pool resources* from a group of hosts into their components (CPU/RAM) and make them available for running containers. Also make sure the resources don't become exhausted via over provisioning or host failure.
* *Service supervision* provide a service load balancer/entry point and make sure the service remains running.
* *Scale up/down functionality* scale a service (automatic or manually) by providing on operator to create more instances.
* *System metadata* provides stats about running instances, scheduling, and container health.

Running a scheduler has obvious benefits over running containers by hand, but to run some of these schedulers requires a long list of dependencies that are not trivial to set up and maintain. Enter Hashicorp's Nomad, from the team that brought you [Consul](https://www.consul.io/), [Vagrant](https://www.vagrantup.com/), [Packer](https://www.packer.io/), [Terraform](https://terraform.io/), [Vault](https://www.vaultproject.io/), and recently [Otto](https://ottoproject.io/). Nomad attempts to give you all of the container scheduler benefits without any of the complexity. It is a single binary (and optional config file) making it simple to deploy and get started. You don't need to make any changes to your existing containers and can get started with just a few commands.

## Understanding Nomad
Nomad is built to be operationally simple. So simple in fact that we can easily create an example cluster to play with on your local machine. So let's dive by playing with nomad in our very own test cluster.

### Spin up local cluster
We are going to leverage Vagrant to automatically provision multiple machines that we can use to demonstrate container scheduling with Nomad. These machines will be:
* Nomad server (1)
* Consul server (1)
* Docker host (3)

To get started, perform a git clone on [nomad-intro](https://github.com/dontrebootme/nomad-intro). Make sure you have [Vagrant installed](https://docs.vagrantup.com/v2/installation/).

```
git clone https://github.com/dontrebootme/nomad-intro
cd nomad-intro
vagrant up
```

This process starts and configures a nomad host using `nomad/install.sh`, a consul host using `consul/install.sh` and three docker hosts using `docker/install.sh`

### Nomad server
A nomad agent in server mode acts as the manager for the agents and applications in your cluster. A normal production cluster would have multiple nomad agents acting in server mode for redundancy, in this demo we are using only one. We describe how we want Nomad to run our applications by defining jobs. I've included a sample job with a task that launches a web server in the [nomad-intro](https://github.com/dontrebootme/nomad-intro) repository. The `.nomad` file mainly defines job, task group and task. A job file will only ever describe a single job, but can have multiple tasks. Additional definitions in the job definition include data such as datacenter, region, instance count, update policy, resources allocated, networking speed, port allocations, and health checks.

To demonstrate how we schedule a job with nomad, send the provided job definition to your server via:
```
steps here
```

Nomad will recieve the job definition and act on that request by scheduling the tasks on the [agent nodes](#agents).

### <a name="agents"></a>Nomad agent
Nomad agents will receive requests for tasks from the server and, if possible, act on those requests. In the example above we asked nomad to find matches 50 instances of microbot tasks which in this example are webservers running in a docker container as defined by the job definition above. We will ask nomad to allocate ports for the containers we launch and monitor the health of those services to act on them should the health check ever fail.

### Consul
Consul is typically seen as two components, service discovery and distributed key value storage. We will focus on the service discovery portion of Consul for an automated way to discover and query our servers that may exist around our environment. Consul works well with nomad, not surprisingly, because it can automatically inform Consul of all running services, their host and port, and the health of those services.

With nomad and Consul in sync, we can automate other systems such as our load balancer to automatically update when we move our services around or when we scale our services with more or fewer containers.

### Further experimentation:
Now that we've covered nomad server, agent, and how we can leverage Consul for service discovery, let's do some further demonstrations of interacting with nomad for tasks such as:
* Scale our microbot service
* Update our service with an automated rolling upgrade
* Deploy a container metrics collection tool using a nomad system jobs
* Query consul microbot service status

## Spin down and clean up


```
# When you're done, you can shut down the cluster using
$ vagrant halt

# And free up some disk space using
$ vagrant destroy -f

#If you want to change any of the configuration/scripts run
$ vagrant provision
```

## Conclusion
In conclusion, there are numerous options for container cluster schedulers. Nomad approach is to keep things operationally simple with less infrastructure needs. We've learned how we can leverage nomad to distribute a task around multiple hosts, scale those tasks, and deploy updates while letting the cluster scheduler handle the placement, supervision, and rolling updates of our service. If you're ready to take your container infrastructure to the next level but don't want to over complicate your infrastrucute then nomad may be the container scheduler you've been waiting for.
