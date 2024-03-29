terraform {
  backend "local" {
    path = "./terraform.tfstate"
  }
}

locals {
  kube_config = {
    config_path    = "~/.kube/config"
    config_context = "minikube"
  }
  namespaces = ["demo-apps", "demo-monitoring", "demo-loki"]
  helm_releases_tmpl = {
    monitoring = {
      enabled         = var.monitoring_helm_enabled
      chart           = "./monitoring-helm"
      namespace       = "demo-monitoring"
      atomic          = true
      cleanup_on_fail = true
      values = [
        file("./monitoring-helm/values.yaml")
      ]
    }
    echo-server = {
      enabled         = var.echo_nginx_server_helm_enabled
      repository      = "https://ealenn.github.io/charts"
      chart           = "echo-server"
      version         = "0.5.0"
      atomic          = true
      cleanup_on_fail = true
      namespace       = "demo-apps"
    }
    python-demo-logs-app = {
      enabled         = var.py_logging_helm_enabled
      chart           = "./demo-services/python-app/deployment"
      namespace       = "demo-monitoring"
      atomic          = true
      cleanup_on_fail = true
      values = [
        file("./demo-services/python-app/deployment/values.yaml")
      ]
    }
    loki = {
      enabled         = var.loki_helm_enabled
      repository      = "https://grafana.github.io/helm-charts"
      chart           = "loki"
      version         = "4.4.2"
      atomic          = false
      cleanup_on_fail = false
      namespace       = "demo-loki"
      values = [
        templatefile("./logging/values-loki.tfpl",
          {
            minio_enabled  = true
            minio_replicas = 1
            minio_user     = "root"
            minio_password = random_string.minio_password.result
            minio_size_gb  = 2
        })
      ]
    }
    promtail = {
      enabled         = var.loki_helm_enabled
      repository      = "https://grafana.github.io/helm-charts"
      chart           = "promtail"
      version         = "6.8.2"
      atomic          = false
      cleanup_on_fail = false
      namespace       = "demo-loki"
      values = [
        templatefile("./logging/values-promtail.tfpl", {})
      ]
    }
  }
  helm_releases = { for k, v in local.helm_releases_tmpl : k => v if v.enabled == true }
}

resource "random_string" "minio_password" {
  length           = 16
  special          = true
  override_special = "^*!"
}
