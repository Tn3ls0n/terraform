# resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

# service principal
module "service_principal" {
  source                 = "./modules/servicePrincipal"
  api_application        = var.api_application
  web_application        = var.web_application
  service_principal_name = var.service_principal_name
}

# key vault
module "key_vault" {
  source              = "./modules/keyVault"
  key_vault_name      = var.key_vault_name
  key_vault_location  = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  spn_obj_id          = module.service_principal.service_principal_object_id
  spn_client_id       = module.service_principal.service_principal_client_id
  spn_secret          = module.service_principal.service_principal_client_secret

  depends_on = [module.service_principal]
}

# aks
module "aks" {
  source                  = "./modules/azureKubernetesService"
  aks_vnet_name           = var.aks_vnet_name
  aks_subnet_name         = var.aks_subnet_name
  resource_group_name     = azurerm_resource_group.rg.name
  resource_group_location = azurerm_resource_group.rg.location
  cluster_name            = var.cluster_name
  dns_name                = var.dns_name
  spn_client_id           = module.service_principal.service_principal_client_id
  spn_secret              = module.service_principal.service_principal_client_secret

  depends_on = [module.key_vault, module.service_principal]

}
