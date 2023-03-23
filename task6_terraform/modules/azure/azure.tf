resource "azurerm_resource_group" "azurevm" {
  name     = "my-resource-group"
  location = var.location
}

resource "azurerm_virtual_network" "azurevm" {
  name                = "my-virtual-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.azurevm.location
  resource_group_name = azurerm_resource_group.azurevm.name
}

resource "azurerm_subnet" "azurevm" {
  name                 = "my-subnet"
  resource_group_name  = azurerm_resource_group.azurevm.name
  virtual_network_name = azurerm_virtual_network.azurevm.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "azurevm" {
  name                = "my-nsg"
  location            = azurerm_resource_group.azurevm.location
  resource_group_name = azurerm_resource_group.azurevm.name

  security_rule {
    name                       = "ssh"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "https"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "http"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

    security_rule {
    name                       = "grafana"
    priority                   = 1004
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "azurevm" {
  name                = "my-nic"
  location            = azurerm_resource_group.azurevm.location
  resource_group_name = azurerm_resource_group.azurevm.name

  ip_configuration {
    name                          = "my-ip-config"
    subnet_id                     = azurerm_subnet.azurevm.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.azurevm.id
  }
}

resource "azurerm_public_ip" "azurevm" {
  name                = "my-public-ip"
  location            = azurerm_resource_group.azurevm.location
  resource_group_name = azurerm_resource_group.azurevm.name
  allocation_method   = "Static"
}

resource "azurerm_linux_virtual_machine" "azurevm" {
  name                  = "my-vm"
  location              = azurerm_resource_group.azurevm.location
  resource_group_name   = azurerm_resource_group.azurevm.name
  size                  = "Standard_DS1_v2"
  admin_username        = "ubuntu"
  user_data           = filebase64("C:\\Users\\95\\Desktop\\DevOps_lessons\\git\\task6_terraform\\modules\\azure\\grafana.sh")
  network_interface_ids = [azurerm_network_interface.azurevm.id]
  os_disk {
    name                 = "my-os-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  computer_name = "myvm"
  admin_ssh_key {
    username   = "ubuntu"
    public_key = file(var.public_key)
  }
}

output "public_ip_address_Azure" {
  description = "Public IP Address of the VM"
  value       = azurerm_public_ip.azurevm.ip_address
}

