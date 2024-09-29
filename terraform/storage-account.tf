resource "azurerm_storage_account" "storage" {
  name                     = var.app_name
  location                 = var.location
  resource_group_name      = azurerm_resource_group.flixtube.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
