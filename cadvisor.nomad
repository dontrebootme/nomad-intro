job "cadvisor" {
  region = "global"

  datacenters = ["nomad-intro"]

  group "infra" {
    count = 3

    task "cadvisor" {
      driver = "docker"
      config {
        image = "google/cadvisor"
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
          port "http" {
          }
        }
      }
    }
  }
}
