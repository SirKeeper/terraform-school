provider "azurerm" {
  #whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "~>1.40"
}

locals {
  prefix = "p4"
}

resource "azurerm_resource_group" "practica4" {
  name     = "${local.prefix}_RG"
  location = "North Europe"
}

resource "azurerm_network_interface" "bot-nic0" {
  name                      = "bot-nic-bot"
  location                  = "${azurerm_resource_group.practica4.location}"
  resource_group_name       = "${azurerm_resource_group.practica4.name}"
  network_security_group_id = azurerm_network_security_group.bastion.id

  ip_configuration {
    name                          = "ip_bot_subnet"
    subnet_id                     = "${azurerm_subnet.bastion.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}

resource "azurerm_public_ip" "bot-pub-ip" {
  name                = "${var.prefix}-bastionpip"
  location            = azurerm_resource_group.practica4.location
  resource_group_name = azurerm_resource_group.practica4.name
  allocation_method   = "Dynamic"
}


resource "azurerm_virtual_machine" "bot-vm" {
  name                  = "bot-vm"
  location              = "${azurerm_resource_group.practica4.location}"
  resource_group_name   = "${azurerm_resource_group.practica4.name}"
  network_interface_ids = ["${azurerm_network_interface.bot-nic0.id}", "${azurerm_network_interface.bot-nic1.id}"]
  vm_size               = "Standard_F2"

  storage_image_reference {
    publisher = "MicrosoftOSTC"
    offer     = "FreeBSD"
    sku       = "11.1"
    version   = "latest"
  }

  storage_os_disk {
    name              = "bot-vm-osdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = bot-p4
    admin_username = testadmin
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${local.admin_username}/.ssh/authorized_keys"
      key_data = local.public_ssh_key
    }
  }

}
