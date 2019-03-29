// Primary
output "primary_consul_workers" {
  value = "${module.primarycluster.workers}"
}


output "primary_consul_servers" {
  value = "${module.primarycluster.servers}"
}


output "VAULT_WEB_UI" {
  value = "${module.primarycluster.vault_ui}"
}


output "NOMAD_WEB_UI" {
  value = "${module.primarycluster.nomad_ui}"
}

output "CONSUL_WEB_UI" {
  value = "${module.primarycluster.consul_lb}"
}

output "FABIO_LB" {
  value = "${module.primarycluster.fabio_lb}"
}

// output "Fabio_LB" {
//   value = "${module.primarycluster.fabio_lb}"
// }


