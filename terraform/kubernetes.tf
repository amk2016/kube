
# 01-deployment

resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "hello"
    labels = {
      App = "hello"
    }
  }  spec {
    replicas = 3
    selector {
      match_labels = {
        App = "hello"
      }
    }
    template {
      metadata {
        labels = {
          App = "hello"
        }
      }
      spec {
        container {
          image = "nginxdemos/hello:latest"
          name  = "hello-container"          
		  port {
            container_port = 80
          }          resources {
            limits = {
              cpu    = "50m"
              memory = "100Mi"
            }
            requests = {
              cpu    = "25m"
              memory = "10Mi"
            }
          }
        }
      }
    }
  }
}

# 02-service

resource "kubernetes_service" "nginx" {
  metadata {
    name = "hello"
  }
  spec {
    selector = {
      App = kubernetes_deployment.nginx.spec.0.template.0.metadata[0].labels.App
    }
    port {
      node_port   = 31000
      port        = 80
      target_port = 80
    }    type = "NodePort"
  }
}



# 03-autoscaler

resource "kubernetes_horizontal_pod_autoscaler" "nginx" {
  metadata {
    name = "hello"
  }

  spec {
    min_replicas = 3
    max_replicas = 10

    scale_target_ref {
      kind = "Deployment"
      name = "hello"
    }

    behavior {
      scale_down {

        policy {
          period_seconds = 60
          type           = "Percent"
          value          = 30
        }
      }
      scale_up {

        policy {
          period_seconds = 60
          type           = "Percent"
          value          = 70
        }

      }
    }
  }
}

# 04-networkpolicy #1

resource "kubernetes_network_policy" "nginx1" {
  metadata {
    name      = "deny-all"
    namespace = "default"
  }

  spec {
    pod_selector {}
    
    policy_types = ["Ingress"]
  }
}


# 05-networkpolicy #2

resource "kubernetes_network_policy" "nginx2" {
  metadata {
    name      = "allow-http"
    namespace = "default"
  }

  spec {
    pod_selector {
      match_expressions {
        key      = "name"
        operator = "In"
        values   = ["app", "hello"]
      }
    }

    ingress {
      ports {
        port     = "http"
        protocol = "TCP"
      }


      from {}

    }

    policy_types = ["Ingress"]
  }
}