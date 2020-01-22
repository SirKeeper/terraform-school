#Configure the Azure Provider
provider "azurerm" {
  #whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "~>1.40"
}

locals {
  prefix = "p4"
}
#Create a resource group
resource "azurerm_resource_group" "practica4" {
  name     = "${local.prefix}_RG"
  location = "North Europe"
}

output "resource_group_name" {
  value = azurerm_resource_group.practica4.name
}

resource "azurerm_virtual_network" "bastion-net" {
  name                = "virtualNetwork1"
  location            = "${azurerm_resource_group.practica4.location}"
  resource_group_name = "${azurerm_resource_group.practica4.name}"
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]
}

resource "azurerm_subnet" "bastion-subnet" {
  name                 = "bastion-subnet"
  resource_group_name  = "${azurerm_resource_group.practica4.name}"
  virtual_network_name = "${azurerm_virtual_network.bastion-net.name}"
  address_prefix       = "10.0.1.0/24"
}

resource "azurerm_network_security_group" "bastion" {
  name                = "bastiontSecurityGroup"
  location            = "${azurerm_resource_group.practica4.location}"
  resource_group_name = "${azurerm_resource_group.practica4.name}"

  security_rule {
    name                       = "ssh_access"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
