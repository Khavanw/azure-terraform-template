# This Terraform configuration creates a Flex Consumption plan app in Azure Functions 
# with the required Storage account and Blob Storage deployment container.

# Random String for unique naming of resources
resource "random_string" "name" {
  length  = 8
  special = false
  upper   = false
  lower   = true
  numeric = false
}

# Resource Group (custom qua var.rg_name)
resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = coalesce(var.rg_name, local.rg_default)
}

# Create a storage account
resource "azurerm_storage_account" "sa" {
  name                     = coalesce(var.sa_name, local.sa_default)
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = var.sa_account_tier
  account_replication_type = var.sa_account_replication_type
}

# Create a storage container
resource "azurerm_storage_container" "sc" {
  name                  = "appdeploy"
  storage_account_id    = azurerm_storage_account.sa.id
  container_access_type = "private"
}

# Create a Log Analytics workspace for Application Insights
resource "azurerm_log_analytics_workspace" "log_aw" {
  name                = coalesce(var.ws_name, local.ws_default)
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# Create an Application Insights instance for monitoring
resource "azurerm_application_insights" "ai" {
  name                = coalesce(var.ai_name, local.ai_default)
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"
  workspace_id = azurerm_log_analytics_workspace.log_aw.id
}

# Create a service plan
resource "azurerm_service_plan" "sp" {
  name                = coalesce(var.asp_name, local.asp_default)
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku_name            = "B1"
  os_type             = "Linux"
}

# Create a Linux function app
resource "azurerm_linux_function_app" "az_linux" {
  name                = coalesce(var.func_name, local.func_default)
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.sp.id

  storage_account_name       = azurerm_storage_account.sa.name
  storage_account_access_key = azurerm_storage_account.sa.primary_access_key

  site_config {
    application_stack {
      python_version = "3.12"
    }
  }
}


# Create a function app
resource "azurerm_function_app_function" "az_func" {
  name            = "example-function-app-function"
  function_app_id = azurerm_linux_function_app.az_linux.id
  language        = "Python"
  test_data = jsonencode({
    "name" = "Azure"
  })
  config_json = jsonencode({
    "bindings" = [
      {
        "authLevel" = "function"
        "direction" = "in"
        "methods" = [
          "get",
          "post",
        ]
        "name" = "req"
        "type" = "httpTrigger"
      },
      {
        "direction" = "out"
        "name"      = "$return"
        "type"      = "http"
      },
    ]
  })
}