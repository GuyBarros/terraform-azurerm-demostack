
output "vault_ui" {
  value = "http://${azurerm_public_ip.vault-awg[0].fqdn}:8200/"
  }
  

  output "consul_lb" {
  value = "http://${azurerm_public_ip.consul-lb-pip.fqdn}:8500/"
  }

output "servers" {
  value = [azurerm_public_ip.servers-pip.*.fqdn]
}

output "workers" {
  value = [azurerm_public_ip.workers-pip.*.fqdn]
}
