
output "consul_servers" {
    value = "${formatlist("http://%s:8500/", azurerm_public_ip.server-pip.*.fqdn,)}"
}

/**
output "nomad_workers_consul_ui" {
  value = "${formatlist("http://%s:8500/", aws_instance.workers.*.public_ip,)}"
}

output "nomad_workers_ui" {
  value = "${formatlist("http://%s:3000/", aws_instance.workers.*.public_ip)}"
}

*/