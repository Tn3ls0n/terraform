resource "azurerm_resource_group" "aks_rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_virtual_network" "aks_vnet" {
  name                = var.aks_vnet_name
  resource_group_name = azurerm_resource_group.aks_rg.name
  location            = azurerm_resource_group.aks_rg.location
  address_space       = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = var.aks_subnet_name
  resource_group_name  = azurerm_resource_group.aks_rg.name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = ["10.0.0.0/25"]
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = var.cluster_name
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = var.dns_name


  default_node_pool {
    name            = "pool1"
    node_count      = 2
    vm_size         = "Standard_D2_v2"
    os_disk_size_gb = "30"
  }

  #linux_profile {
  #  admin_username = var.admin_username
  #  ssh_key {
  #    key_data = data.azurerm_key_vault_secret.ssh_public_key.value
  #  }
  #}

  service_principal {
    client_id     = var.spn_client_id
    client_secret = var.spn_secret
  }
}
