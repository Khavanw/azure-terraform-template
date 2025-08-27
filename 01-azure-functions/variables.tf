variable "rg_name" {
  type        = string
  default     = ""
  description = "The name of the Azure resource group. If blank, a random name will be generated."
}

variable "resource_group_name_prefix" {
  type        = string
  default     = "rg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "resource_group_location" {
  type        = string
  default     = "eastus"
  description = "Location of the resource group."
}

variable "sa_account_tier" {
  description = "The tier of the storage account. Possible values are Standard and Premium."
  type        = string
  default     = "Standard"
}

variable "sa_account_replication_type" {
  description = "The replication type of the storage account. Possible values are LRS, GRS, RAGRS, and ZRS."
  type        = string
  default     = "LRS"
}

variable "sa_name" {
  description = "The name of the storage account. If blank, a random name will be generated."
  type        = string
  default     = ""
}

variable "ws_name" {
  description = "The name of the Log Analytics workspace. If blank, a random name will be generated."
  type        = string
  default     = ""
}

variable "ai_name" {
  description = "The name of the Application Insights instance. If blank, a random name will be generated."
  type        = string
  default     = ""
}

variable "func_name" {
  description = "The name of Function App instance. If blank, a random name will be generated."
  type        = string
  default     = ""
}

variable "asp_name" {
  description = "The name of the App Service Plan. If blank, a random name will be generated."
  type        = string
  default     = ""
}

variable "fa_name" {
  description = "The name of the Function App. If blank, a random name will be generated."
  type        = string
  default     = ""
}

variable "runtime_name" {
  description = "The name of the language worker runtime."
  type        = string
  default     = "node" # Allowed: dotnet-isolated, java, node, powershell, python
}

variable "runtime_version" {
  description = "The version of the language worker runtime."
  type        = string
  default     = "20" # Supported versions: see https://aka.ms/flexfxversions
}

variable "env" {
  type        = string
  description = "Environment short name (dev|stg|prod)"
  default     = "dev"
}

variable "prefix" {
  type        = string
  description = "Project prefix for naming"
  default     = "demo"
}

locals {
  # short suffix to increase uniqueness
  sa_suffix = random_string.name.result

  # Default names if not provided in tfvars
  rg_default   = "${var.prefix}-${var.env}-rg"
  asp_default  = "${var.prefix}-${var.env}-asp"
  ws_default   = "${var.prefix}-${var.env}-law"
  ai_default   = "${var.prefix}-${var.env}-appi"
  func_default = "${var.prefix}-${var.env}-func"

  # Storage account: normalize and trim to 24 characters
  sa_default_raw = lower("${var.prefix}${var.env}${local.sa_suffix}")
  sa_default     = substr(local.sa_default_raw, 0, 24)
}
