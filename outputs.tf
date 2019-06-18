// Primary

output "Consul" {
  value = module.primarycluster.consul_lb
}

output "Nomad" {
  value = module.primarycluster.nomad_ui
}

output "Vault" {
  value = module.primarycluster.vault_ui
}

output "Fabio" {
  value = module.primarycluster.fabio_lb
}

output "Hashi_UI" {
  value = module.primarycluster.hashi_ui
}

output "servers" {
  value = module.primarycluster.servers
}


output "workers" {
  value = module.primarycluster.workers
}
