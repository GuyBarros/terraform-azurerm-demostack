data "template_file" "workers" {
  depends_on = ["azurerm_public_ip.workers-pip"]
  count      = "${var.workers}"

  template = "${join("\n", list(
    file("${path.module}/templates/shared/base.sh"),
    file("${path.module}/templates/shared/docker.sh"),

    file("${path.module}/templates/workers/consul.sh"),
    file("${path.module}/templates/workers/vault.sh"),
    file("${path.module}/templates/workers/nomad.sh"),
    

    file("${path.module}/templates/shared/cleanup.sh"),
  ))}"

  vars {
    hostname      = "${var.hostname}-workers-${count.index}"
    private_ip    = "${element(azurerm_network_interface.workers-nic.*.private_ip_address, count.index)}"
    public_ip     = "${element(azurerm_public_ip.workers-pip.*.ip_address, count.index)}"
    demo_username = "${var.demo_username}"
    demo_password = "${var.demo_password}"

    enterprise      = "${var.enterprise}"
    vaultlicense    = "${var.vaultlicense}"
    consullicense   = "${var.consullicense}"
    kmskey          = "${azurerm_key_vault.demostack.id}"
    subscription_id = "${var.subscription}"
    tenant_id       = "${var.tenant}"
    client_id       = "${var.client_id}"
    client_secret   = "${var.client_secret}"
    fqdn            = "${element(azurerm_public_ip.workers-pip.*.fqdn, count.index)}"
    node_name       = "${var.hostname}-workers-${count.index}"
    me_ca           = "${var.ca_cert_pem}"
    me_cert         = "${element(tls_locally_signed_cert.servers.*.cert_pem, count.index)}"
    me_key          = "${element(tls_private_key.servers.*.private_key_pem, count.index)}"

    # Consul
    consul_url            = "${var.consul_url}"
    consul_ent_url        = "${var.consul_ent_url}"
    consul_gossip_key     = "${base64encode(random_id.consul_gossip_key.hex)}"
    consul_join_tag_key   = "ConsulJoin"
    consul_join_tag_name  = "demostack"
    consul_join_tag_value = "${local.consul_join_tag_value}"
    consul_master_token   = "${random_id.consul_master_token.hex}"
    consul_servers        = "${var.workers}"

    # Nomad
    nomad_url        = "${var.nomad_url}"
    nomad_gossip_key = "${base64encode(random_id.nomad_gossip_key.hex)}"
    nomad_servers    = "${var.workers}"

    # Nomad jobs
    fabio_url   = "${var.fabio_url}"
    hashiui_url = "${var.hashiui_url}"

    # Vault
    vault_url        = "${var.vault_url}"
    vault_ent_url    = "${var.vault_ent_url}"
    vault_root_token = "${random_id.vault-root-token.hex}"
    vault_servers    = "${var.workers}"
  }
}

# Gzip cloud-init config
data "template_cloudinit_config" "workers" {
  count = "${var.workers}"

  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = "${element(data.template_file.workers.*.rendered, count.index)}"
  }
}

resource "azurerm_network_interface" "workers-nic" {
  count                     = "${var.workers}"
  name                      = "${var.demo_prefix}workers-nic-${count.index}"
  location                  = "${var.location}"
  resource_group_name       = "${azurerm_resource_group.demostack.name}"
  network_security_group_id = "${azurerm_network_security_group.demostack-sg.id}"

  # network_security_group_id = "${azurerm_network_security_group.demostack-sg.id}"

  ip_configuration {
    name                          = "${var.demo_prefix}-${count.index}-ipconfig"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${element(azurerm_public_ip.workers-pip.*.id, count.index)}"
  }
  tags {
    name      = "Guy Barros"
    ttl       = "13"
    owner     = "guy@hashicorp.com"
    demostack = "${local.consul_join_tag_value}"
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "workers" {
  count                   = "${var.workers}"
  network_interface_id    = "${element(azurerm_network_interface.workers-nic.*.id, count.index)}"
  ip_configuration_name   = "${var.demo_prefix}-${count.index}-ipconfig"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.lb.id }"
}

# Every Azure Virtual Machine comes with a private IP address. You can also 
# optionally add a public IP address for Internet-facing applications and 
# demo environments like this one.
resource "azurerm_public_ip" "workers-pip" {
  count               = "${var.workers}"
  name                = "${var.demo_prefix}-workers-ip-${count.index}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.demostack.name}"
  allocation_method   = "Static"
  domain_name_label   = "${var.hostname}-workers-${count.index}"
  sku                 = "Standard"

  /*
    tags {
    name  = "Guy Barros"
    ttl   = "13"
    owner = "guy@hashicorp.com"
    demostack = "${local.consul_join_tag_value}"
  }
*/
}

# And finally we build our demostack workers. This is a standard Ubuntu instance.
# We use the shell provisioner to run a Bash script that configures demostack for 
# the demo environment. Terraform supports several different types of 
# provisioners including Bash, Powershell and Chef.
resource "azurerm_virtual_machine" "workers" {
  count               = "${var.workers}"
  name                = "${var.hostname}-workers-${count.index}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.demostack.name}"
  vm_size             = "${var.vm_size}"

  network_interface_ids         = ["${element(azurerm_network_interface.workers-nic.*.id, count.index)}"]
  delete_os_disk_on_termination = "true"

  storage_image_reference {
    publisher = "${var.image_publisher}"
    offer     = "${var.image_offer}"
    sku       = "${var.image_sku}"
    version   = "${var.image_version}"
  }

  storage_os_disk {
    name              = "${var.hostname}-worker-osdisk-${count.index}"
    managed_disk_type = "Standard_LRS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    disk_size_gb      = "${var.storage_disk_size}"
  }

  os_profile {
    computer_name  = "${var.hostname}-workers-${count.index}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
    custom_data    = "${element(data.template_cloudinit_config.workers.*.rendered, count.index)}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags {
    name      = "Guy Barros"
    ttl       = "13"
    owner     = "guy@hashicorp.com"
    demostack = "${local.consul_join_tag_value}"
  }
}
