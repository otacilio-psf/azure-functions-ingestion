resource "azurerm_service_plan" "service_plan_linux" {
  name                = "service-plan-${var.project_initials}-01"
  resource_group_name = azurerm_resource_group.project.name
  location            = azurerm_resource_group.project.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "func" {
  name                = "func-${var.project_initials}-01"
  resource_group_name = azurerm_resource_group.project.name
  location            = azurerm_resource_group.project.location

  storage_account_name       = azurerm_storage_account.stga_funtion.name
  storage_account_access_key = azurerm_storage_account.stga_funtion.primary_access_key
  service_plan_id            = azurerm_service_plan.service_plan_linux.id

  app_settings = {
    AZURE_STORAGE_TENANT_ID     = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault.akv.vault_uri}secrets/${azurerm_key_vault_secret.datalake_access_sp_id.name}/)"
    AZURE_STORAGE_CLIENT_ID     = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault.akv.vault_uri}secrets/${azurerm_key_vault_secret.datalake_access_sp_secret.name}/)"
    AZURE_STORAGE_CLIENT_SECRET = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault.akv.vault_uri}secrets/${azurerm_key_vault_secret.datalake_access_sp_tenant.name}/)"
    AZURE_STORAGE_ACCOUNT_NAME = "${azurerm_storage_account.stga_datalake.name}"
    AZURE_STORAGE_CONTAINER_NAME = "${azurerm_storage_data_lake_gen2_filesystem.datalake.name}"
  }

  site_config {
    application_stack {
        python_version = "3.8"
    }
  
  }

  identity {
      type = "SystemAssigned"
  }
}

resource "azurerm_key_vault_access_policy" "funct_app" {
  key_vault_id = azurerm_key_vault.akv.id
  tenant_id    = azurerm_linux_function_app.func.identity[0].tenant_id
  object_id    = azurerm_linux_function_app.func.identity[0].principal_id

  key_permissions = [
    "Get", "List", 
  ]

  secret_permissions = [
    "Set", "Get",
  ]

  depends_on = [
    azurerm_linux_function_app.func
  ]
}