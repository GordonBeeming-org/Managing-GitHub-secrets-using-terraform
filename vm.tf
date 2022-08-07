
resource "azurerm_network_interface" "app-external" {
  name                = "${var.environment_name}-demodso-ext-app-nic"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "app-external"
    subnet_id                     = azurerm_subnet.external.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

data "template_file" "app-cloud-init" {
  template = file("vm.sh")
  vars = {
    resource_group_name = azurerm_resource_group.main.name
    storage_account_name = azurerm_storage_account.main.name
  }
}

resource "azurerm_linux_virtual_machine" "app" {
  name                            = "${var.environment_name}-demodso-vm"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  size                            = var.app_vm_size
  admin_username                  = var.app_admin_user
  admin_password                  = var.app_admin_password
  disable_password_authentication = false

  custom_data    = base64encode(data.template_file.app-cloud-init.rendered)

  network_interface_ids = [
    azurerm_network_interface.app-external.id,
  ]

  identity {
    type = "UserAssigned"
    identity_ids = [ azurerm_user_assigned_identity.app.id ]
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-groovy"
    sku       = "20_10-gen2"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "StandardSSD_ZRS"
    caching              = "ReadWrite"
  }
}

variable "app_vm_size" {
  type = string
}
variable "app_admin_user" {
  type = string
  sensitive = true
}
variable "app_admin_password" {
  type = string
  sensitive = true
}
