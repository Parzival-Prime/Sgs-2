resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-rg"
  location = "${var.location}"
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name                = "${var.prefix}-aks-cluster"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.prefix

  default_node_pool {
    name       = "system"
    node_count = 1
    vm_size    = "Standard_D2as_v6"
  }

  identity {
    type = "SystemAssigned" 
  }

  node_provisioning_profile {
    default_node_pools = "Auto"
  }
}
