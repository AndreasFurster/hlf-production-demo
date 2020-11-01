resource "null_resource" "daisycon_configure" {
  depends_on = [ null_resource.daisycon_install ]

  provisioner "file" {
    source      = "../scripts/hlf-start-node.sh"
    destination = "~/hlf-start-node.sh"
  }

  provisioner "file" {
    source      = "../config/crypto-config-daisycon.yaml"
    destination = "~/crypto-config.yaml"
  }

  provisioner "file" {
    source      = "../config/docker-compose-daisycon.yaml"
    destination = "~/docker-compose-orderer.yaml"
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
    user = azurerm_linux_virtual_machine.daisycon_vm.admin_username
    host = azurerm_public_ip.daisycon_vmip.ip_address
    private_key = tls_private_key.daisycon_ssh.private_key_pem
  }
}