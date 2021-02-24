resource "azurerm_virtual_network" "sec488-vnet" {
  name                = "sec488-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.sec488-rg.location
  resource_group_name = azurerm_resource_group.sec488-rg.name
}

resource "azurerm_subnet" "sec488-subnet" {
  name                 = "sec488-subnet"
  resource_group_name  = azurerm_resource_group.sec488-rg.name
  virtual_network_name = azurerm_virtual_network.sec488-vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_public_ip" "sec488-hrweb-pip" {
  name                = "sec488-hrweb-pip"
  resource_group_name = azurerm_resource_group.sec488-rg.name
  location            = azurerm_resource_group.sec488-rg.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "sec488-hrweb-nic" {
  name                = "sec488-hrweb-nic"
  location            = azurerm_resource_group.sec488-rg.location
  resource_group_name = azurerm_resource_group.sec488-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sec488-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.sec488-hrweb-pip.id
  }
}

resource "azurerm_network_security_group" "sec488-nsg" {
  name                = "sec488-nsg"
  location            = azurerm_resource_group.sec488-rg.location
  resource_group_name = azurerm_resource_group.sec488-rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "ICMP"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "sec488-hrweb-association" {
  network_interface_id      = azurerm_network_interface.sec488-hrweb-nic.id
  network_security_group_id = azurerm_network_security_group.sec488-nsg.id
}
