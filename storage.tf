
resource "azurerm_storage_account" "main" {
  name                            = "demo2${var.environment_name}dso"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = false

  lifecycle {
    prevent_destroy = true
  }

}

resource "azurerm_storage_container" "appdata" {
  name                  = "appdata"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_role_assignment" "app_mainstorage_access" {
  scope                = azurerm_storage_account.main.id
  role_definition_name = "Reader and Data Access"
  principal_id         = azurerm_user_assigned_identity.app.principal_id
}

resource "azurerm_storage_container" "demo" {
  name                  = "demo"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"

  lifecycle {
    prevent_destroy = true
  }
}
