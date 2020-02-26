data "template_file" "workers" {
  depends_on = [azurerm_public_ip.workers-pip,azurerm_public_ip.consul-lb-pip]
  count      = var.workers

  template = "${join("\n", list(
    file("${path.module}/templates/shared/base.sh"),
    file("${path.module}/templates/shared/docker.sh"),
    file("${path.module}/templates/shared/run-proxy.sh"),
    file("${path.module}/templates/workers/consul.sh"),
    file("${path.module}/templates/workers/vault.sh"),
  ))}"



  vars = {
    location = var.location
    hostname      = "${var.hostname}-workers-${count.index}"
    private_ip    = azurerm_network_interface.workers-nic[count.index].private_ip_address
    public_ip     = azurerm_public_ip.workers-pip[count.index].ip_address
    enterprise      = var.enterprise
    vaultlicense    = var.vaultlicense
    consullicense   = var.consullicense
    kmskey          = azurerm_key_vault.demostack.id
    subscription_id = var.subscription_id
    tenant_id       = var.tenant_id
    client_id       = var.client_id
    client_secret   = var.client_secret
    fqdn            = azurerm_public_ip.workers-pip[count.index].fqdn
    node_name       = "${var.hostname}-workers-${count.index}"
    me_ca           = var.ca_cert_pem
    me_cert         = "${element(tls_locally_signed_cert.workers.*.cert_pem, count.index)}"
    me_key          = "${element(tls_private_key.workers.*.private_key_pem, count.index)}"
    
    # Consul
    consul_url            = var.consul_url
    consul_ent_url        = var.consul_ent_url
    consul_gossip_key     = var.consul_gossip_key
    consul_join_tag_key   = "ConsulJoin"
    consul_join_tag_name  = "demostack"
    consul_join_tag_value = var.consul_join_tag_value
    consul_master_token   = var.consul_master_token
    consul_servers        = var.workers

    # Vault
    vault_url        = var.vault_url
    vault_ent_url    = var.vault_ent_url
    vault_root_token = random_id.vault-root-token.hex
    vault_servers    = var.workers
  }
}

# Gzip cloud-init config
data "template_cloudinit_config" "workers" {
  depends_on = [data.template_file.workers]
  count      = var.workers

  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.workers[count.index].rendered
  }
}

resource "azurerm_subnet" "workers" {
  name                 = "${var.demo_prefix}-workers"
  virtual_network_name = azurerm_virtual_network.awg.name
  resource_group_name  = azurerm_resource_group.demostack.name
  address_prefix       = "10.0.40.0/24"
}

resource "azurerm_subnet_network_security_group_association" "workers" {
  subnet_id                 = azurerm_subnet.workers.id
  network_security_group_id = azurerm_network_security_group.demostack-sg.id
}

resource "azurerm_network_interface" "workers-nic" {
  count                     = var.workers
 name                      = "${var.demo_prefix}workers-nic-${count.index}"
  location                  = var.location
 resource_group_name       = azurerm_resource_group.demostack.name
  # network_security_group_id = azurerm_network_security_group.demostack-sg.id
  

  ip_configuration {
    name                          = "${var.demo_prefix}-${count.index}-ipconfig"
    subnet_id                     = azurerm_subnet.workers.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.workers-pip[count.index].id
  }
  tags = {
    name      =var.owner
    TTL       = var.TTL
    owner     = var.owner
    demostack = var.consul_join_tag_value
 }
}


# Every Azure Virtual Machine comes with a private IP address. You can also 
# optionally add a public IP address for Internet-facing applications and 
# demo environments like this one.
resource "azurerm_public_ip" "workers-pip" {
  count               = var.workers
 name                = "${var.demo_prefix}-workers-ip-${count.index}"
  location            = var.location
 resource_group_name = azurerm_resource_group.demostack.name
  allocation_method   = "Static"
  domain_name_label   = "${var.hostname}-workers-${count.index}"
  sku                 = "Standard"

  
    tags = {
    name  =var.owner
    TTL   = var.TTL
    owner = var.owner
    demostack = var.consul_join_tag_value
 }

}



# And finally we build our demostack workers. This is a standard Ubuntu instance.
# We use the shell provisioner to run a Bash script that configures demostack for 
# the demo environment. Terraform supports several different types of 
# provisioners including Bash, Powershell and Chef.
resource "azurerm_virtual_machine" "workers" {
    depends_on = [data.template_file.workers,data.template_cloudinit_config.workers]
  count               = var.workers
 name                = "${var.hostname}-workers-${count.index}"
  location            = var.location
 resource_group_name = azurerm_resource_group.demostack.name
  vm_size             = var.vm_size

  network_interface_ids         = ["${azurerm_network_interface.workers-nic[count.index].id}"]
  delete_os_disk_on_termination = "true"

  storage_image_reference {
    publisher = var.image_publisher
   offer     =  var.image_offer
   sku       =  var.image_sku
   version   =  var.image_version
 }

  storage_os_disk {
    name              = "${var.hostname}-worker-osdisk-${count.index}"
    managed_disk_type = "Standard_LRS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    disk_size_gb      = var.storage_disk_size
 }

  os_profile {
    computer_name  = "${var.hostname}-workers-${count.index}"
    admin_username = var.admin_username
   admin_password = var.admin_password
    custom_data =  element(data.template_cloudinit_config.workers.*.rendered,  count.index  )


  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    name      =var.owner
    TTL       = var.TTL
    owner     = var.owner
    demostack = var.consul_join_tag_value
 }
}
