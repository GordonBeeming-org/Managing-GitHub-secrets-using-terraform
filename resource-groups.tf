
resource "azurerm_resource_group" "main" {
  name     = "demo2-${var.environment_name}-rg"
  location = var.deploy_region

  lifecycle {
    prevent_destroy = true
  }
}

output "main_resource_group" {
  value = azurerm_resource_group.main.name
}
