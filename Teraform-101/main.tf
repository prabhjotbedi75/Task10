#provider
 terraform {
     required_providers {
         azurerm = {
             source = "hashicorp/azurerm"
             version = "~>2.0"
         }
     }
 }
 provider "azurerm" {
  features {}

 }

#your code goes here

data "azurerm_resource_group" "terraform-rg"{
  name = "ptest_group"
}

data "azurerm_virtual_network" "terraform-vnet"{
    name = "pvnet2"
    resource_group_name = data.azurerm_resource_group.terraform-rg.name
}

#refer to a subnet
data "azurerm_subnet" "terraform-subnet" {
  name = "AGSubnet"
  resource_group_name = data.azurerm_resource_group.terraform-rg.name
  virtual_network_name = data.azurerm_virtual_network.terraform-vnet.name
}

# Create public IPs
resource "azurerm_public_ip" "terraform-public-ip" {
    name = "myPublicIP"
    location = "Central India"
    resource_group_name = data.azurerm_resource_group.terraform-rg.name
    allocation_method = "Dynamic"
}

# create a network interface
resource "azurerm_network_interface" "terraform-nic" {
  name                = "myNic"
  location            = "Central India"
  resource_group_name = data.azurerm_resource_group.terraform-rg.name

  ip_configuration {
    name  = "nic-config_ip"
    subnet_id = data.azurerm_subnet.terraform-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.terraform-public-ip.id
  }
}

# Create (and display) an SSH Key
resource "tls_private_key" "linux_key" {
  algorithm = "RSA"
  rsa_bits = 4096
}
output "tls_private_key" {
  value = tls_private_key.linux_key.private_key_pem
  sensitive = true
}
resource "local_file" "linuxkey" {
  filename = "linuxkey.pem"
  content = tls_private_key.linux_key.private_key_pem
}

# Creating a Virtual Machine
resource "azurerm_linux_virtual_machine" "terraform-vm" {
    name = "terraformVM"
    location = "Central India"
    resource_group_name = data.azurerm_resource_group.terraform-rg.name
    network_interface_ids = [azurerm_network_interface.terraform-nic.id]
    size = "Standard_B1s"

    os_disk {
      name = "terraformOSdisk"
      caching = "ReadWrite"
      storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-focal"
        sku       = "20_04-lts-gen2"
        version   = "latest"
    }

    computer_name = "terraformVM"
    admin_username = "TFuser"
    disable_password_authentication = true

    admin_ssh_key {
        username       = "TFuser"
        public_key     = tls_private_key.linux_key.public_key_openssh
    }

  
}