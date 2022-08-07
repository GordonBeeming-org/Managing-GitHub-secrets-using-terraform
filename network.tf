
resource "azurerm_virtual_network" "main" {
  name                = "${var.environment_name}-demo2dso-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "external" {
  name                 = "external"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  resource_group_name  = "${azurerm_resource_group.main.name}"
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "pip" {
  name                = "${var.environment_name}-dso-pip"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_network_security_group" "main-nsg" {
  name                = "${var.environment_name}-demo2dso-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    access                     = "Deny"
    direction                  = "Inbound"
    name                       = "http"
    priority                   = 150
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "80"
    destination_address_prefix = azurerm_network_interface.app-external.private_ip_address
  }
  
  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "https"
    priority                   = 100
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "443"
    destination_address_prefix = azurerm_network_interface.app-external.private_ip_address
  }
  
  security_rule {
    access                     = var.sshAccess
    direction                  = "Inbound"
    name                       = "ssh-app"
    priority                   = 160
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "22"
    destination_address_prefix = azurerm_network_interface.app-external.private_ip_address
  }
  
}

resource "azurerm_network_interface_security_group_association" "app-external" {
  network_interface_id      = azurerm_network_interface.app-external.id
  network_security_group_id = azurerm_network_security_group.main-nsg.id
}

variable "sshAccess" {
  type = string
  default = "Deny"
}

output "pip" {
  value = azurerm_public_ip.pip.ip_address
}
