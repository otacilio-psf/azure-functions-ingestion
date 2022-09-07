resource "azurerm_key_vault_secret" "datalake_access_sp_id" {
  name         = "sp-datalake-contributor-id"
  value        = var.SP_DATA_LAKE_CONTRIBUTOR_ID
  key_vault_id = azurerm_key_vault.akv.id

  depends_on = [
    azurerm_key_vault_access_policy.deployer
  ]
}


resource "azurerm_key_vault_secret" "datalake_access_sp_secret" {
  name         = "sp-datalake-contributor-secret"
  value        = var.SP_DATA_LAKE_CONTRIBUTOR_SECRET
  key_vault_id = azurerm_key_vault.akv.id

  depends_on = [
    azurerm_key_vault_access_policy.deployer
  ]
}

resource "azurerm_key_vault_secret" "datalake_access_sp_tenant" {
  name         = "sp-datalake-contributor-tenant"
  value        = var.TENANT_ID
  key_vault_id = azurerm_key_vault.akv.id

  depends_on = [
    azurerm_key_vault_access_policy.deployer
  ]
}