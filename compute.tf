resource "random_password" "sec488-hrweb-password" {
  length           = 16
  special          = true
  override_special = "_%@"
  min_lower        = 2
  min_upper        = 2
  min_special      = 2
  min_numeric      = 2
}

resource "azurerm_linux_virtual_machine" "sec488-hrweb" {
  name                            = "sec488-rbi"
  resource_group_name             = azurerm_resource_group.sec488-rg.name
  location                        = azurerm_resource_group.sec488-rg.location
  size                            = "Standard_B2s"
  admin_username                  = "student"
  admin_password                  = random_password.sec488-hrweb-password.result
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.sec488-hrweb-nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "8_2"
    version   = "latest"
  }
  custom_data = base64encode(file("${path.module}/scripts/rbi-install.sh"))
}
