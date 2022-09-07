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

  site_config {
    application_stack {
        python_version = "3.9"
    }
  }
}

