output "servers" {
  value = "${formatlist("http://%s:8500/", azurerm_public_ip.servers-pip.*.fqdn,)}"
}

output "service_identity_principal_id" {
  value = "${azurerm_user_assigned_identity.demostack.principal_id}"
}

output "key_vault_name" {
  value = "${azurerm_key_vault.demostack.name}"
}

/**
output "vault-lb" {
  value = "${azurerm_public_ip.lb.fqdn}"
}


output "nomad_workers_consul_ui" {
  value = "${formatlist("http://%s:8500/", aws_instance.workers.*.public_ip,)}"
}

output "nomad_workers_ui" {
  value = "${formatlist("http://%s:3000/", aws_instance.workers.*.public_ip)}"
}

*/

