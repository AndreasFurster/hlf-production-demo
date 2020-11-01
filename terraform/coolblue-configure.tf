resource "null_resource" "coolblue_configure" {
  depends_on = [ null_resource.coolblue_install ]

  provisioner "file" {
    source      = "../scripts/hlf-start-node.sh"
    destination = "~/hlf-start-node.sh"
  }

  provisioner "file" {
    source      = "../config/crypto-config-coolblue.yaml"
    destination = "~/crypto-config.yaml"
  }

  provisioner "file" {
    source      = "../config/docker-compose-coolblue.yaml"
    destination = "~/docker-compose-node.yaml"
  }
  
  provisioner "remote-exec" {
    inline = [
      "sleep 10",
      "chmod +x ~/hlf-start-node.sh",
      "~/hlf-start-node.sh",
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