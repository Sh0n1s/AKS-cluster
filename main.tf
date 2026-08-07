resource "azurerm_resource_group" "aks_rg" {
  name     = "rg-aks-cluster"
  location = "polandcentral"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "my-aks-cluster"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "myaksdns"
  kubernetes_version        = "1.35"
  automatic_channel_upgrade = "patch"

  oidc_issuer_enabled = true

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_B2s_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }
}

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true

  depends_on = [azurerm_kubernetes_cluster.aks]
}
