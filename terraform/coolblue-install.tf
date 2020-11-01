resource "null_resource" "coolblue_install" {
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
    user = azurerm_linux_virtual_machine.coolblue_vm.admin_username
    host = azurerm_public_ip.coolblue_vmip.ip_address
    private_key = tls_private_key.coolblue_ssh.private_key_pem
  }
}