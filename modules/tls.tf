# servers private key
resource "tls_private_key" "servers" {
  count       = "${var.servers}"
  algorithm   = "ECDSA"
  ecdsa_curve = "P521"
}

# servers signing request
resource "tls_cert_request" "servers" {
  count           = "${var.servers}"
  key_algorithm   = "${element(tls_private_key.servers.*.algorithm, count.index)}"
  private_key_pem = "${element(tls_private_key.servers.*.private_key_pem, count.index)}"

  subject {
    common_name  = "${var.hostname}-servers-${count.index}.node.consul"
    organization = "HashiCorp Consul Connect Demo"
  }

  dns_names = [
    # Consul
    "*.cloudapp.azure.com",

    "${var.hostname}-servers-${count.index}.node.consul",
    "consul.service.consul",
    "servers.dc1.consul",

    # Nomad
    "nomad.service.consul",

    "client.global.nomad",
    "servers.global.nomad",
    "vault.service.consul",
    "active.vault.service.consul",
    "standby.vault.service.consul",

    # Common
    "localhost",
  ]

  # Vault
  #"${element(azurerm_public_ip.demostack-pip.*.fqdn, count.index)}",

  #"${var.namespace}-servers-${count.index}.node.consul",

  /*
  ip_addresses = [
    "127.0.0.1",
  ]
  */
}

# servers certificate
resource "tls_locally_signed_cert" "servers" {
  count              = "${var.servers}"
  cert_request_pem   = "${element(tls_cert_request.servers.*.cert_request_pem, count.index)}"
  ca_key_algorithm   = "${var.ca_key_algorithm}"
  ca_private_key_pem = "${var.ca_private_key_pem}"
  ca_cert_pem        = "${var.ca_cert_pem}"

  validity_period_hours = 720 # 30 days

  allowed_uses = [
    "client_auth",
    "digital_signature",
    "key_agreement",
    "key_encipherment",
    "server_auth",
  ]
}



# Vault initial root token
resource "random_id" "vault-root-token" {
  byte_length = 8
  prefix      = "${var.hostname}-"
}

# Client private key
resource "tls_private_key" "workers" {
  count       = "${var.workers}"
  algorithm   = "ECDSA"
  ecdsa_curve = "P521"
}


# Client signing request
resource "tls_cert_request" "workers" {
  count           = "${var.workers}"
  key_algorithm   = "${element(tls_private_key.workers.*.algorithm, count.index)}"
  private_key_pem = "${element(tls_private_key.workers.*.private_key_pem, count.index)}"

  subject {
    common_name  = "${var.hostname}-worker-${count.index}.node.consul"
    organization = "HashiCorp Consul Connect Demo"
  }

  dns_names = [
    # Consul
    "${var.hostname}-worker-${count.index}.node.consul",

    # Nomad
    "nomad.service.consul",

    "client.global.nomad",

    # Common
    "localhost",
  ]

  /*
  ip_addresses = [
    "127.0.0.1",
  ]
  */
}

//Finish Worker References
# Client certificate

resource "tls_locally_signed_cert" "workers" {
  count              = "${var.workers}"
  cert_request_pem   = "${element(tls_cert_request.workers.*.cert_request_pem, count.index)}"
  ca_key_algorithm   = "${var.ca_key_algorithm}"
  ca_private_key_pem = "${var.ca_private_key_pem}"
  ca_cert_pem        = "${var.ca_cert_pem}"

  validity_period_hours = 720 # 30 days

  allowed_uses = [
    "client_auth",
    "digital_signature",
    "key_agreement",
    "key_encipherment",
    "server_auth",
  ]
}

# Consul gossip encryption key
resource "random_id" "consul_gossip_key" {
  byte_length = 16
}

# Consul master token
resource "random_id" "consul_master_token" {
  byte_length = 16
}

# Consul join key
resource "random_id" "consul_join_tag_value" {
  byte_length = 16
}

# Nomad gossip encryption key
resource "random_id" "nomad_gossip_key" {
  byte_length = 16
}
