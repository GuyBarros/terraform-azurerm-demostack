// Primary


output "primary_consul_servers" {
  value = "${module.primarycluster.servers}"
}
