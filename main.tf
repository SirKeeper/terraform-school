#Configure the Azure Provider
provider "azurerm" {
  #whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=1.40"
}

#Create a resource group
resource "azurerm_resource_group" "p1" {
  name     = var.resource_group
  location = "North Europe"
}
