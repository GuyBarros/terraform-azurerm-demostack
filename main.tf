/*
//--------------------------EMEA-SE_PLAYGROUND-2019-----------------------------------------
# Using a single workspace:
terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "emea-se-playground-2019"

    workspaces {
      name = "Guy-Azure-Demostack"
    }
  }
}
*/

//--------------------------------------------------------------------
// Workspace Data
data "terraform_remote_state" "emea_se_playground_tls_root_certificate" {
  backend = "remote"

  config = {
    hostname     = "app.terraform.io"
    organization = "emea-se-playground-2019"
    workspaces = {
      name = "tls-root-certificate"
    }
  } //config
}

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
  nomad_url       = var.nomad_url
  nomad_ent_url   = var.nomad_ent_url
  vault_url       = var.vault_url
  vault_ent_url   = var.vault_ent_url
  TTL             = var.TTL
  cni_plugin_url  = var.cni_plugin_url

  # ca_key_algorithm      = var.ca_key_algorithm
  # ca_private_key_pem    = var.ca_private_key_pem
  # ca_cert_pem           = var.ca_cert_pem
  # consul_join_tag_value = "${var.hostname}-${var.consul_join_tag_value}"
  # consul_gossip_key     = var.consul_gossip_key
  # consul_master_token   = var.consul_master_token
  # nomad_gossip_key      = var.nomad_gossip_key


  # EMEA-SE-PLAYGROUND
  ca_key_algorithm      = data.terraform_remote_state.emea_se_playground_tls_root_certificate.outputs.ca_key_algorithm
  ca_private_key_pem    = data.terraform_remote_state.emea_se_playground_tls_root_certificate.outputs.ca_private_key_pem
  ca_cert_pem           = data.terraform_remote_state.emea_se_playground_tls_root_certificate.outputs.ca_cert_pem
  consul_join_tag_value = "${var.hostname}-${data.terraform_remote_state.emea_se_playground_tls_root_certificate.outputs.consul_join_tag_value}"
  consul_gossip_key     = data.terraform_remote_state.emea_se_playground_tls_root_certificate.outputs.consul_gossip_key
  consul_master_token   = data.terraform_remote_state.emea_se_playground_tls_root_certificate.outputs.consul_master_token
  nomad_gossip_key      = data.terraform_remote_state.emea_se_playground_tls_root_certificate.outputs.nomad_gossip_key
}
