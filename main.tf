# service principal
module "servicePrincipal" {
  source                 = "./modules/servicePrincipal"
  api_application        = var.api_application
  web_application        = var.web_application
  service_principal_name = var.service_principal_name

}

# resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}
