# Add a Public IP address
resource "azurerm_public_ip" "tweakers_vmip" {
  name                = "tweakers-vm-ip"
  allocation_method   = "Static"
  location            = var.location
  resource_group_name = var.rgname
}

output "tweakers_public_ip" {
  value = azurerm_public_ip.tweakers_vmip.ip_address
}

resource "local_file" "tweakers_public_ip_file" {
    content  = azurerm_public_ip.tweakers_vmip.ip_address
    filename = "../outputs/tweakers_ip.txt"
}

# DNS record for public IP
resource "azurerm_dns_a_record" "tweakers_dns_record" {
  name                = "peer0.tweakers"
  zone_name           = "sbc.andreasfurster.nl"
  resource_group_name = var.rgname
  ttl                 = 1
  records             = [azurerm_public_ip.tweakers_vmip.ip_address]
}

# NIC with Public IP Address
resource "azurerm_network_interface" "tweakers_nic" {
  name                = "tweakers-vm-nic"
  location            = var.location
  resource_group_name = var.rgname

  ip_configuration {
    name                          = "external"
    subnet_id                     = azurerm_subnet.vmsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.tweakers_vmip.id
  }
}

resource "tls_private_key" "tweakers_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# output "tweakers_tls_private_key" { value = tls_private_key.tweakers_ssh.private_key_pem }

resource "local_file" "tweakers_private_key" {
    content  = tls_private_key.tweakers_ssh.private_key_pem
    filename = "../outputs/tweakers_private_key.pem"
}

resource "azurerm_linux_virtual_machine" "tweakers_vm" {
  name                  = "tweakers-vm"
  location              = var.location
  resource_group_name   = var.rgname
  network_interface_ids = [azurerm_network_interface.tweakers_nic.id]
  size                  = "Standard_D2s_v3"

  os_disk {
    name                 = "tweakers-vm-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "tweakers-vm"
  admin_username                  = "vmadmin"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "vmadmin"
    public_key = tls_private_key.tweakers_ssh.public_key_openssh
  }
}

resource "null_resource" "tweakers_dependancies" {
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
    user = azurerm_linux_virtual_machine.tweakers_vm.admin_username
    host = azurerm_public_ip.tweakers_vmip.ip_address
    private_key = tls_private_key.tweakers_ssh.private_key_pem
  }
}