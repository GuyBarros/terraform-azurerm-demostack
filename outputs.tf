// Primary

output "primary_consul_servers" {
  value = "${module.primarycluster.servers}"
}

output "service_identity_principal_id" {
  value = "${module.primarycluster.service_identity_principal_id}"
}

output "key_vault_name" {
  value = "${module.primarycluster.key_vault_name}"
}
