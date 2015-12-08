# Define a job called my-service
job "microbot-service" {
  # Job should run in the US region
  region = "global"

  # Spread tasks between us-west-1 and us-east-1
  datacenters = ["nomad-intro"]

  # Rolling updates should follow this policy
  update {
    stagger = "10s"
    max_parallel = 5
  }

  group "webs" {
    # We want 50 web servers
    count = 50

    # Create a web front end using a docker image
    task "microbot" {
      driver = "docker"
      config {
        image = "dontrebootme/microbot"
      }
      service {
        port = "http"
        check {
          type = "http"
          path = "/"
          interval = "10s"
          timeout = "2s"
        }
      }
      env {
        DEMO_NAME = "nomad-intro"
      }
      resources {
        cpu = 100
        memory = 32
        network {
          mbits = 100
          # Request for a dynamic port
          port "http" {
          }
        }
      }
    }
  }
}
