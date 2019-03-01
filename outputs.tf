// Primary

output "primary_consul_workers" {
  value = "${module.primarycluster.workers}"
}


output "primary_consul_servers" {
  value = "${module.primarycluster.servers}"
}


output "Vault_UI" {
  value = "${module.primarycluster.vault_ui}"
}

output "Fabio_UI" {
  value = "${module.primarycluster.fabio_ui}"
}


