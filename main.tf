# Using a single workspace:

terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "emea-se-playground"
    token        = "<TFE-API-TOKEN>"

    workspaces {
      name = "Guy-Azure-Demostack"
    }
  }
}

//--------------------------------------------------------------------
// Workspace Data
data "terraform_remote_state" "emea_se_playground_tls_root_certificate" {
  backend = "remote"

  config {
    hostname     = "app.terraform.io"
    organization = "emea-se-playground"

    workspaces {
      name = "tls-root-certificate"
    }
  } //config
}

/**
*/

module "primarycluster" {
  source              = "./modules"
  resource_group      = "${var.resource_group}"
  hostname            = "${var.hostname}"
  location            = "${var.location}"
  admin_username      = "${var.admin_username}"
  admin_password      = "${var.admin_password}"
  demo_username       = "${var.demo_username}"
  demo_password       = "${var.demo_password}"
  subscription        = "${var.subscription}"
  tenant              = "${var.tenant}"
  client_id           = "${var.client_id}"
  client_secret       = "${var.client_secret}"
  owner               = "${var.owner}"
  public_key          = "${var.public_key}"
  servers             = "${var.servers}"
  workers             = "${var.workers}"
  vaultlicense        = "${var.vaultlicense}"
  consullicense       = "${var.consullicense}"
  enterprise          = "${var.enterprise}"
  consul_url          = "${var.consul_url}"
  consul_ent_url      = "${var.consul_ent_url}"
  packer_url          = "${var.packer_url}"
  sentinel_url        = "${var.sentinel_url}"
  consul_template_url = "${var.consul_template_url}"
  envconsul_url       = "${var.envconsul_url}"
  fabio_url           = "${var.fabio_url}"
  hashiui_url         = "${var.hashiui_url}"
  nomad_url           = "${var.nomad_url}"
  nomad_ent_url       = "${var.nomad_ent_url}"
  terraform_url       = "${var.terraform_url}"
  vault_url           = "${var.vault_url}"
  vault_ent_url       = "${var.vault_ent_url}"
  created-by          = "${var.created-by}"
  sleep-at-night      = "${var.sleep-at-night}"
  TTL                 = "${var.TTL}"
  ca_key_algorithm    = "${data.terraform_remote_state.emea_se_playground_tls_root_certificate.ca_key_algorithm}"
  ca_private_key_pem  = "${data.terraform_remote_state.emea_se_playground_tls_root_certificate.ca_private_key_pem}"
  ca_cert_pem         = "${data.terraform_remote_state.emea_se_playground_tls_root_certificate.ca_cert_pem}"

  //  ca_key_algorithm   = "${module.rootcertificate.ca_key_algorithm}"
  //  ca_private_key_pem = "${module.rootcertificate.ca_private_key_pem}"
  //  ca_cert_pem        = "${module.rootcertificate.ca_cert_pem}"
}

/*
module "rootcertificate" {
  source              = "github.com/GuyBarros/terraform-tls-certificate"
  version = "0.0.1"
  algorithm = "ECDSA"
  ecdsa_curve = "P521"
  common_name   = "service.consul"
  organization = "service.consul"
  validity_period_hours = 720
  is_ca_certificate = true
}
*/

