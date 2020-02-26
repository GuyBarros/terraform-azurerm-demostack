
module "primarycluster" {
  source          = "./modules"
  resource_group  = var.resource_group
  hostname        = var.hostname
  location        = var.location
  admin_username  = var.admin_username
  admin_password  = var.admin_password
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  owner           = var.owner
  servers         = var.servers
  workers         = var.workers
  vaultlicense    = var.vaultlicense
  consullicense   = var.consullicense
  enterprise      = var.enterprise
  consul_url      = var.consul_url
  consul_ent_url  = var.consul_ent_url
  fabio_url       = var.fabio_url
  vault_url       = var.vault_url
  vault_ent_url   = var.vault_ent_url
  TTL             = var.TTL
  
  ca_key_algorithm      = var.ca_key_algorithm
  ca_private_key_pem    = var.ca_private_key_pem
  ca_cert_pem           = var.ca_cert_pem
  consul_join_tag_value = "${var.hostname}-${var.consul_join_tag_value}"
  consul_gossip_key     = var.consul_gossip_key
  consul_master_token   = var.consul_master_token
  


}
