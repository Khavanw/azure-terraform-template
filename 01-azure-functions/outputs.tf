output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "sa_name" {
  value = azurerm_storage_account.sa.name
}

output "asp_name" {
  value = azurerm_service_plan.sp.name
}

output "fa_name" {
  value = azurerm_function_app_function.az_func.name
}

output "fa_url" {
  value = "https://${azurerm_function_app_function.az_func.name}.azurewebsites.net"
}