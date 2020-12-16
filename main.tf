terraform {
  required_version = ">= 0.12"
}

provider "azurerm" {
  version = "=2.13.0"

  features {}
}

provider "helm" {
  version = "1.2.2"
  kubernetes {
    host = azurerm_kubernetes_cluster.cluster.kube_config[0].host

    client_key             = base64decode(azurerm_kubernetes_cluster.cluster.kube_config[0].client_key)
    client_certificate     = base64decode(azurerm_kubernetes_cluster.cluster.kube_config[0].client_certificate)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.cluster.kube_config[0].cluster_ca_certificate)
    load_config_file       = false
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "sonarqube-kubernetes-rg"
  location = "west europe"
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name       = "aks"
  location   = azurerm_resource_group.rg.location
  dns_prefix = "aks"

  resource_group_name = azurerm_resource_group.rg.name
  kubernetes_version  = "1.18.10"

  default_node_pool {
    name       = "aks"
    node_count = "1"
    vm_size    = "Standard_D2s_v3"
  }

kube_dashboard {
      enabled = true
    }

  identity {
    type = "SystemAssigned"
  }
}

resource "helm_release" "sonarqube" {
  name  = "sonarqube"
  chart = "oteemocharts/sonarqube"

  set {
    name  = "rbac.create"
    value = "true"
  }
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.cluster.kube_config_raw
}