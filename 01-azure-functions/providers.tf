terraform {
  required_version = ">=1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  subscription_id             = var.subscription_id
  tenant_id                   = var.tenant_id
  client_id                   = var.client_id
  client_secret               = var.client_secret
  features {}
}

# DATA
data "azurerm_client_config" "current" {}

data "azurerm_subscription" "primary" {}

data "http" "current_ip" {
  url = "https://api.ipify.org?format=text" # or "https://checkip.amazonaws.com"
}

# VARIABLES
variable "subscription_id" {
  type        = string
  description = <<-EOT
  Subscription ID inside which to create our resources
  This is the unit of billing.
  `az account list -o table` shows the list of subscriptions you
  have access to after you login with `az login`.
  EOT
  default     = null
}

variable "tenant_id" {
  type        = string
  description = <<-EOT
  Tenant ID inside which our subscription is housed
  `az account show -s SUBSCRIPTION_ID -o table` will show the ID of the tenant
  after you have logged in with `az login`.
  EOT
  default     = null
}

variable "client_id" {
  type        = string
  description = <<-EOT
  Client ID for the Service Principal used to login to Azure AD and create resources in the subscription.
  `az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/SUBSCRIPTION_ID"` will create a Service Principal
  with the Contributor role on the subscription. The output of this command will show the client ID.
  EOT
  default     = null
}

variable "client_secret" {
  type        = string
  description = <<-EOT
  Client Secret for the Service Principal used to login to Azure AD and create resources in the subscription.
  `az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/SUBSCRIPTION_ID"` will create a Service Principal
  with the Contributor role on the subscription. The output of this command will show the client secret.
  EOT
  default     = null
}