#Configure the Azure Provider
provider "azurerm" {
  #whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "~>1.40"
}

locals {
  prefix = "p3"
}
#Create a resource group
resource "azurerm_resource_group" "practica" {
  name     = "${local.prefix}_RG"
  location = "North Europe"
}

output "resource_group_name" {
  value = azurerm_resource_group.practica.name
}
