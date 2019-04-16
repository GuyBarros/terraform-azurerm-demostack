// Primary

output "0 - Consul" {
  value = "${module.primarycluster.consul_lb}"
}

output "1 - Nomad" {
  value = "${module.primarycluster.nomad_ui}"
}

output "2 - Vault" {
  value = "${module.primarycluster.vault_ui}"
}

output "3 - Fabio" {
  value = "${module.primarycluster.fabio_lb}"
}

output "4 - Hashi UI" {
  value = "${module.primarycluster.hashi_ui}"
}

output "5 - servers" {
  value = "${module.primarycluster.servers}"
}

output "6 - workers" {
  value = "${module.primarycluster.workers}"
}

// output "Fabio_LB" {
//   value = "${module.primarycluster.fabio_lb}"
// }

