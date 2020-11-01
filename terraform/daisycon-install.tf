resource "null_resource" "daisycon_install" {
  provisioner "file" {
    source      = "../scripts/install.sh"
    destination = "~/install.sh"
  }
  
  provisioner "remote-exec" {
    inline = [
      "sleep 10",
      "chmod +x ~/install.sh",
      "~/install.sh",
      "sleep 10",
    ]
  } 

  connection {
    type = "ssh"
    user = azurerm_linux_virtual_machine.daisycon_vm.admin_username
    host = azurerm_public_ip.daisycon_vmip.ip_address
    private_key = tls_private_key.daisycon_ssh.private_key_pem
  }
}