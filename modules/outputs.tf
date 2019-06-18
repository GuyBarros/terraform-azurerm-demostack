
output "vault_ui" {
  value = "http://azurerm_public_ip.vault-awg.fqdn:8200/"
  }

output "nomad_ui" {
  value = "http://azurerm_public_ip.nomad-awg.fqdn:4646/"
  }


output "fabio_lb" {
  value = "http://azurerm_public_ip.consul-lb-pip.fqdn:9999/"
  }
  

  output "consul_lb" {
  value = "http://azurerm_public_ip.consul-lb-pip.fqdn:8500/"
  }

output "servers" {
  value = "${formatlist("ssh %s@%s", var.admin_username, azurerm_public_ip.servers-pip[*].fqdn,)}"
}

output "workers" {
  value = "${formatlist("ssh %s@%s", var.demo_username, azurerm_public_ip.workers-pip[*].fqdn,)}"
}


output "hashi_ui" {
  value = "http://azurerm_public_ip.workers-pip.0.fqdn:3000"
}