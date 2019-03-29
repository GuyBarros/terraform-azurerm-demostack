
output "vault_ui" {
  value = "http://${azurerm_public_ip.vault-awg.fqdn}:8200/"
  }

output "nomad_ui" {
  value = "http://${azurerm_public_ip.nomad-awg.fqdn}:4646/"
  }


output "fabio_lb" {
  value = "http://${azurerm_public_ip.consul-lb-pip.fqdn}:9999/"
  }
  

  output "consul_lb" {
  value = "http://${azurerm_public_ip.consul-lb-pip.fqdn}:8500/"
  }

output "servers" {
  value = "${formatlist("http://%s:8500/", azurerm_public_ip.servers-pip.*.fqdn,)}"
}

output "workers" {
  value = "${formatlist("http://%s:8500/", azurerm_public_ip.workers-pip.*.fqdn,)}"
}

/*
output "nomad_workers_consul_ui" {
  value = "${formatlist("http://%s:8500/", aws_instance.workers.*.public_ip,)}"
}

output "nomad_workers_ui" {
  value = "${formatlist("http://%s:3000/", aws_instance.workers.*.public_ip)}"
}

*/

