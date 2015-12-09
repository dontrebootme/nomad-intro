job "microbot" {
  region = "global"

  datacenters = ["nomad-intro"]

  # Rolling updates
  update {
    stagger = "10s"
    max_parallel = 5
  }

  group "web" {
    # We want 9 web servers initially
    count = 9

    task "microbot" {
      driver = "docker"
      config {
        image = "dontrebootme/microbot:v1"
        port_map {
          http = 80
        }
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
          port "http" {}
        }
      }
    }
  }
}
