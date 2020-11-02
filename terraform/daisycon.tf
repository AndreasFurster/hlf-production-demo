# Add a Public IP address
resource "azurerm_public_ip" "daisycon_vmip" {
  name                = "daisycon-vm-ip"
  allocation_method   = "Static"
  location            = var.location
  resource_group_name = var.rgname
}

output "daisycon_public_ip" {
  value = azurerm_public_ip.daisycon_vmip.ip_address
}

resource "local_file" "daisycon_public_ip_file" {
    content  = azurerm_public_ip.daisycon_vmip.ip_address
    filename = "../outputs/daisycon_ip.txt"
}


# NIC with Public IP Address
resource "azurerm_network_interface" "daisycon_nic" {
  name                = "daisycon-vm-nic"
  location            = var.location
  resource_group_name = var.rgname

  ip_configuration {
    name                          = "external"
    subnet_id                     = azurerm_subnet.vmsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.daisycon_vmip.id
  }
}

resource "tls_private_key" "daisycon_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# output "daisycon_tls_private_key" { value = tls_private_key.daisycon_ssh.private_key_pem }

resource "local_file" "daisycon_private_key" {
    content  = tls_private_key.daisycon_ssh.private_key_pem
    filename = "../outputs/daisycon_private_key.pem"
}

resource "azurerm_linux_virtual_machine" "daisycon_vm" {
  name                  = "daisycon-vm"
  location              = var.location
  resource_group_name   = var.rgname
  network_interface_ids = [azurerm_network_interface.daisycon_nic.id]
  size                  = "Standard_D2s_v3"

  os_disk {
    name                 = "daisycon-vm-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "daisycon-vm"
  admin_username                  = "vmadmin"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "vmadmin"
    public_key = tls_private_key.daisycon_ssh.public_key_openssh
  }
}


resource "null_resource" "daisycon_dependancies" {
  provisioner "file" {
    source      = "./scripts/dependancies.sh"
    destination = "~/dependancies.sh"
  }
  
  provisioner "remote-exec" {
    inline = [
      "chmod +x ~/dependancies.sh",
      "~/dependancies.sh",
    ]
  }

  provisioner "file" {
    source      = "./scripts/hlf-binaries.sh"
    destination = "~/hlf-binaries.sh"
  }
  
  provisioner "remote-exec" {
    inline = [
      "chmod +x ~/hlf-binaries.sh",
      "~/hlf-binaries.sh",
    ]
  }

  connection {
    type = "ssh"
    user = azurerm_linux_virtual_machine.daisycon_vm.admin_username
    host = azurerm_public_ip.daisycon_vmip.ip_address
    private_key = tls_private_key.daisycon_ssh.private_key_pem
  }
}