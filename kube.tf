data "digitalocean_kubernetes_versions" "v" {
  version_prefix = "1.24."
}

resource "digitalocean_kubernetes_cluster" "liberland" {
  name         = "liberland"
  region       = "ams3"
  auto_upgrade = true
  version      = data.digitalocean_kubernetes_versions.v.latest_version

  maintenance_policy {
    start_time  = "04:00"
    day         = "tuesday"
  }

  node_pool {
    name       = "system"
    size       = "s-2vcpu-4gb"
    auto_scale = true
    min_nodes  = 1
    max_nodes  = 3

    labels = {
      purpose = "system"
    }
  }
}

resource "digitalocean_kubernetes_node_pool" "apps" {
  cluster_id = digitalocean_kubernetes_cluster.liberland.id

  name       = "apps"
  size       = "s-4vcpu-8gb"
  auto_scale = true
  min_nodes  = 1
  max_nodes  = 3

  labels = {
    purpose = "apps"
  }
}

output "kubeconfig" {
  value     = digitalocean_kubernetes_cluster.liberland.kube_config.0.raw_config
  sensitive = true
}

