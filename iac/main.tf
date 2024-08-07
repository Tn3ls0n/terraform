resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

module "service_principal" {
  source          = "./modules/servicePrincipal"
  api_application = var.api_application
}

#module "key_vault" {
#  source                  = "./modules/keyVault"
#  key_vault_name          = var.key_vault_name
#  resource_group_name     = azurerm_resource_group.rg.name
#  resource_group_location = azurerm_resource_group.rg.location
#  api_application         = var.api_application
#  spn_client_id           = module.service_principal.service_principal_client_id
#  spn_password            = module.service_principal.service_principal_password
#  depends_on              = [module.service_principal]
#}

module "aks" {
  source                  = "./modules/azureKubernetesService"
  resource_group_name     = azurerm_resource_group.rg.name
  resource_group_location = azurerm_resource_group.rg.location
  cluster_name            = var.cluster_name
  system_node_count       = var.system_node_count
  spn_object_id           = module.service_principal.service_principal_client_id
  spn_password            = module.service_principal.service_principal_password
  depends_on              = [module.service_principal]
}

module "acr" {
  source                  = "./modules/azureContainerRegistry"
  resource_group_name     = azurerm_resource_group.rg.name
  resource_group_location = azurerm_resource_group.rg.location
  acr_name                = var.acr_name
  spn_object_id           = module.service_principal.service_principal_object_id
  kubelet_id              = module.aks.aks_kubelet.0.object_id
  depends_on              = [module.aks]
}
