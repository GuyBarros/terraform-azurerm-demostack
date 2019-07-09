
module "primarycluster" {
  source              = "./modules"
  resource_group      = var.resource_group
  hostname            = var.hostname
  location            = var.location
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  demo_username       = var.demo_username
  demo_password       = var.demo_password
  subscription_id     = var.subscription_id
  tenant_id           = var.tenant_id
  client_id           = var.client_id
  client_secret       = var.client_secret
  owner               = var.owner
  servers             = var.servers
  workers             = var.workers
  vaultlicense        = var.vaultlicense
  consullicense       = var.consullicense
  enterprise          = var.enterprise
  consul_url          = var.consul_url
  consul_ent_url      = var.consul_ent_url
  packer_url          = var.packer_url
  sentinel_url        = var.sentinel_url
  consul_template_url = var.consul_template_url
  envconsul_url       = var.envconsul_url
  fabio_url           = var.fabio_url
  hashiui_url         = var.hashiui_url
  nomad_url           = var.nomad_url
  nomad_ent_url       = var.nomad_ent_url
  terraform_url       = var.terraform_url
  vault_url           = var.vault_url
  vault_ent_url       = var.vault_ent_url
  created-by          = var.created-by
  sleep-at-night      = var.sleep-at-night
  TTL                 = var.TTL
  run_nomad_jobs      = var.run_nomad_jobs

ca_key_algorithm      = var.ca_key_algorithm
  ca_private_key_pem    = var.ca_private_key_pem
  ca_cert_pem           = var.ca_cert_pem
  consul_join_tag_value = "${var.namespace}-${var.consul_join_tag_value}"
  consul_gossip_key     = var.consul_gossip_key
  consul_master_token   = var.consul_master_token
  nomad_gossip_key      = var.nomad_gossip_key
  

}
