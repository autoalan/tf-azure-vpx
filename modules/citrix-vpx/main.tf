resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.region_name
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.region_name
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.vnet_prefix
}

resource "azurerm_subnet" "snet_mgmt" {
  name                 = var.snet_mgmt_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.snet_mgmt_prefix
}

resource "azurerm_subnet" "snet_client" {
  name                 = var.snet_client_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.snet_client_prefix
}

resource "azurerm_network_security_group" "nsg_mgmt" {
  name                = var.nsg_mgmt_name
  location            = var.region_name
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_group" "nsg_client" {
  name                = var.nsg_client_name
  location            = var.region_name
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "nsr_mgmt_allow" {
  name                        = var.nsr_mgmt_allow_name
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = var.nsr_mgmt_allow_ports
  source_address_prefixes     = var.nsr_mgmt_allow_prefixes
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg_mgmt.name
}

resource "azurerm_network_security_rule" "nsr_mgmt_deny" {
  name                        = var.nsr_mgmt_deny_name
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg_mgmt.name
}

resource "azurerm_network_security_rule" "nsr_client_allow" {
  name                        = var.nsr_client_allow_name
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = var.nsr_client_allow_ports
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg_client.name
}

resource "azurerm_network_security_rule" "nsr_client_deny" {
  name                        = var.nsr_mgmt_deny_name
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg_client.name
}

resource "azurerm_subnet_network_security_group_association" "nsa_mgmt" {
  subnet_id                 = azurerm_subnet.snet_mgmt.id
  network_security_group_id = azurerm_network_security_group.nsg_mgmt.id
}

resource "azurerm_subnet_network_security_group_association" "nsa_client" {
  subnet_id                 = azurerm_subnet.snet_client.id
  network_security_group_id = azurerm_network_security_group.nsg_client.id
}

resource "azurerm_public_ip" "pip_mgmt" {
  name                = var.pip_mgmt_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.region_name
  allocation_method   = "Static"
}

resource "azurerm_public_ip" "pip_client" {
  name                = var.pip_client_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.region_name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "nic_mgmt" {
  name                = var.nic_mgmt_name
  location            = var.region_name
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "management"
    subnet_id                     = azurerm_subnet.snet_mgmt.id
    private_ip_address_allocation = "Static"
    private_ip_address_version    = "IPv4"
    private_ip_address            = var.nic_mgmt_ip
    public_ip_address_id          = azurerm_public_ip.pip_mgmt.id
  }
}

resource "azurerm_network_interface" "nic_client" {
  name                = var.nic_client_name
  location            = var.region_name
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "client"
    subnet_id                     = azurerm_subnet.snet_client.id
    private_ip_address_allocation = "Static"
    private_ip_address_version    = "IPv4"
    private_ip_address            = var.nic_client_ip
    public_ip_address_id          = azurerm_public_ip.pip_client.id
  }
}

resource "azurerm_virtual_machine" "vm" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.region_name
  vm_size             = var.vm_size

  network_interface_ids = [
    azurerm_network_interface.nic_mgmt.id,
    azurerm_network_interface.nic_client.id,
  ]

  primary_network_interface_id = azurerm_network_interface.nic_mgmt.id

  os_profile {
    computer_name  = var.vm_os_computer_name
    admin_username = var.vm_os_admin_username
    admin_password = var.vm_os_admin_password
    custom_data = jsonencode({
      "subnet_11" = var.snet_client_prefix,
      "pvt_ip_11" = azurerm_network_interface.nic_client.private_ip_address,
    })
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  delete_os_disk_on_termination = true

  storage_os_disk {
    name              = var.vm_os_disk_name
    caching           = "ReadWrite"
    managed_disk_type = "Standard_LRS"
    create_option     = "FromImage"
  }

  storage_image_reference {
    publisher = var.vm_image_publisher
    offer     = var.vm_image_offer
    sku       = var.vm_image_sku
    version   =  var.vm_image_version
  }

  plan {
    name      = var.vm_plan_name
    publisher = var.vm_plan_publisher
    product   = var.vm_plan_product
  }
}