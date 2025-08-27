# Azure Functions Terraform Template

This repository provides a Terraform template to deploy Azure Functions and related resources.

## Getting Started

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed
- Azure CLI authenticated

### Usage

#### 1. Initialize Terraform

```sh
terraform init
```

#### 2. Plan and Apply for Development

```sh
terraform plan -var-file=dev.tfvars
terraform apply -var-file=dev.tfvars
```

#### 3. Plan and Apply for Production

```sh
terraform plan -var-file=prod.tfvars
terraform apply -var-file=prod.tfvars
```

## Import Existing Azure Resources

If you already have existing resources in Azure, you can import them into your Terraform state using the following commands. Replace placeholders (`<SUB>`, `<sa-name>`, etc.) with your actual values.

### Resource Group

```sh
terraform import azurerm_resource_group.rg \
  /subscriptions/<SUB>/resourceGroups/rg-kha-dev-core
```

### Storage Account

```sh
terraform import azurerm_storage_account.sa \
  /subscriptions/<SUB>/resourceGroups/rg-kha-dev-core/providers/Microsoft.Storage/storageAccounts/<sa-name>
```

### App Service Plan

```sh
terraform import azurerm_service_plan.sp \
  /subscriptions/<SUB>/resourceGroups/rg-kha-dev-core/providers/Microsoft.Web/serverfarms/<asp-name>
```

### Log Analytics Workspace

```sh
terraform import azurerm_log_analytics_workspace.log_aw \
  /subscriptions/<SUB>/resourceGroups/rg-kha-dev-core/providers/Microsoft.OperationalInsights/workspaces/<ws-name>
```

### Application Insights

```sh
terraform import azurerm_application_insights.ai \
  /subscriptions/<SUB>/resourceGroups/rg-kha-dev-core/providers/microsoft.insights/components/<ai-name>
```

### Linux Function App

```sh
terraform import azurerm_linux_function_app.az_linux \
  /subscriptions/<SUB>/resourceGroups/rg-kha-dev-core/providers/Microsoft.Web/sites/func-kha-dev-api
```

### (Optional) Specific Function in the App

```sh
terraform import azurerm_function_app_function.az_func \
  /subscriptions/<SUB>/resourceGroups/rg-kha-dev-core/providers/Microsoft.Web/sites/func-kha-dev-api/functions/example-function-app-function
```

---

Feel free to customize the variables and resource names as needed for your environment.
