output "service_principal_client_id" {
  value = azuread_service_principal.web_api_sp.client_id
}

output "service_principal_object_id" {
  value = azuread_service_principal.web_api_sp.object_id
}

output "service_principal_password" {
  value     = azuread_service_principal_password.web_api_sp_pw.value
  sensitive = true
}
