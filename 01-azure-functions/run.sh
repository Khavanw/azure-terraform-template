$env:ARM_PROVIDER_ENHANCED_VALIDATION=false
$env:ARM_SUBSCRIPTION_ID = ""
$env:ARM_TENANT_ID       = ""
$env:ARM_CLIENT_ID       = ""
$env:ARM_CLIENT_SECRET   = ""


$RG   = "rg-kha-dev-core"
$FUNC = "func-kha-dev"
$SA   = "<storage-account-name>"
$ASP  = "<app-service-plan-name>"
$LAW  = "<log-analytics-workspace-name>"
$AI   = "<app-insights-name>"
$CONT = "appdeploy" 

terraform init
terraform workspace select dev 2>$null; if ($LASTEXITCODE -ne 0) { terraform workspace new dev; terraform workspace select dev }

terraform import azurerm_resource_group.rg "/subscriptions/$($env:ARM_SUBSCRIPTION_ID)/resourceGroups/$RG"

if ($SA -and -not $SA.StartsWith('<')) {
  terraform import azurerm_storage_account.sa "/subscriptions/$($env:ARM_SUBSCRIPTION_ID)/resourceGroups/$RG/providers/Microsoft.Storage/storageAccounts/$SA"
  terraform import azurerm_storage_container.sc "/subscriptions/$($env:ARM_SUBSCRIPTION_ID)/resourceGroups/$RG/providers/Microsoft.Storage/storageAccounts/$SA/blobServices/default/containers/$CONT"
}
if ($ASP -and -not $ASP.StartsWith('<')) {
  terraform import azurerm_service_plan.sp "/subscriptions/$($env:ARM_SUBSCRIPTION_ID)/resourceGroups/$RG/providers/Microsoft.Web/serverfarms/$ASP"
}
if ($LAW -and -not $LAW.StartsWith('<')) {
  terraform import azurerm_log_analytics_workspace.log_aw "/subscriptions/$($env:ARM_SUBSCRIPTION_ID)/resourceGroups/$RG/providers/Microsoft.OperationalInsights/workspaces/$LAW"
}
if ($AI -and -not $AI.StartsWith('<')) {
  terraform import azurerm_application_insights.ai "/subscriptions/$($env:ARM_SUBSCRIPTION_ID)/resourceGroups/$RG/providers/Microsoft.Insights/components/$AI"
}
terraform import azurerm_linux_function_app.az_linux "/subscriptions/$($env:ARM_SUBSCRIPTION_ID)/resourceGroups/$RG/providers/Microsoft.Web/sites/$FUNC"

terraform plan -refresh-only