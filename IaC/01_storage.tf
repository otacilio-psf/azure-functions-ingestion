resource "azurerm_storage_account" "stga_datalake" {
  name                     = "adls2${var.project_initials}01"
  resource_group_name      = azurerm_resource_group.project.name
  location                 = azurerm_resource_group.project.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"
  
  tags = {
    scope = "analytics"
  }

}

resource "azurerm_storage_data_lake_gen2_filesystem" "datalake" {
  name               = "datalake"
  storage_account_id = azurerm_storage_account.stga_datalake.id

  ace {
    scope = "access"
    type = "user"
    id = var.SP_DATA_LAKE_CONTRIBUTOR_ID
    permissions  = "rwx"
  }

  ace {
    scope = "default"
    type = "user"
    id = var.SP_DATA_LAKE_CONTRIBUTOR_ID
    permissions  = "rwx"
  }

}

resource "azurerm_storage_account" "stga_funtion" {
  name                     = "blob${var.project_initials}functionapp01"
  resource_group_name      = azurerm_resource_group.project.name
  location                 = azurerm_resource_group.project.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
