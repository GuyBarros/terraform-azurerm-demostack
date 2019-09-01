data "template_file" "servers" {
  depends_on = ["azurerm_public_ip.servers-pip", "azurerm_key_vault.demostack"]
  count      = "${var.servers}"

  template = "${join("\n", list(
     file("${path.module}/templates/shared/base.sh"),
    file("${path.module}/templates/shared/docker.sh"),
    file("${path.module}/templates/shared/run-proxy.sh"),
    file("${path.module}/templates/server/consul.sh"),
    file("${path.module}/templates/server/vault.sh"),
    file("${path.module}/templates/server/nomad.sh"),
    file("${path.module}/templates/server/nomad-jobs.sh"),
  ))}"

  
  vars = {
    location      = var.location
    hostname      = "${var.hostname}-servers-${count.index}"
    private_ip    = azurerm_network_interface.servers-nic[count.index].private_ip_address
    public_ip     = azurerm_public_ip.servers-pip[count.index].ip_address
    enterprise    = var.enterprise
    vaultlicense  = var.vaultlicense
    consullicense = var.consullicense
    kmsvaultname  = azurerm_key_vault.demostack.name
    kmskeyname    = azurerm_key_vault_key.demostack.name
    subscription_id = var.subscription_id
    tenant_id     = var.tenant_id
    client_id     = var.client_id
    client_secret = var.client_secret
    object_id     = azurerm_user_assigned_identity.demostack.principal_id
    fqdn          = azurerm_public_ip.servers-pip[count.index].fqdn
    node_name     = "${var.hostname}-servers-${count.index}"
    me_ca         = var.ca_cert_pem
    me_cert       = "${element(tls_locally_signed_cert.servers[*].cert_pem, count.index)}"
    me_key        = "${element(tls_private_key.servers[*].private_key_pem, count.index)}"

    # Consul
    consul_url            = var.consul_url
   consul_ent_url        = var.consul_ent_url
   consul_gossip_key     = var.consul_gossip_key
   consul_join_tag_key   = "ConsulJoin"
    consul_join_tag_name  = var.consul_join_tag_name
    consul_join_tag_value = var.consul_join_tag_value
   consul_master_token   =  var.consul_master_token
   consul_servers        = var.servers

    # Nomad
    nomad_url        = var.nomad_url
   nomad_gossip_key =  var.nomad_gossip_key
   nomad_servers    = var.servers

    # Nomad jobs
    fabio_url   = var.fabio_url
   hashiui_url =  var.hashiui_url
   run_nomad_jobs = var.run_nomad_jobs

    # Vault
    vault_url        = var.vault_url
   vault_ent_url    =  var.vault_ent_url
   vault_root_token = random_id.vault-root-token.hex
    vault_servers    = var.servers
 }
}


# Gzip cloud-init config
data "template_cloudinit_config" "servers" {
  depends_on = ["data.template_file.servers"]
  count      = var.servers

  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.servers[count.index].rendered
  }

}


resource "azurerm_network_interface" "servers-nic" {
  count                     = var.servers
 name                      = "${var.demo_prefix}servers-nic-${count.index}"
  location                  = var.location
 resource_group_name       = azurerm_resource_group.demostack.name
  network_security_group_id = azurerm_network_security_group.demostack-sg.id

  ip_configuration {
    name                          = "${var.demo_prefix}-${count.index}-ipconfig"
    subnet_id                     = azurerm_subnet.servers.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.servers-pip[count.index].id

    }

  tags = {
    name      =var.owner
    TTL       = var.TTL
    owner     = var.owner
    demostack = var.consul_join_tag_value
 }
}

resource "azurerm_subnet" "servers" {
  name                 = "${var.demo_prefix}-servers"
  virtual_network_name = azurerm_virtual_network.awg.name
  resource_group_name  = azurerm_resource_group.demostack.name
  address_prefix       = "10.0.30.0/24"
}




# Every Azure Virtual Machine comes with a private IP address. You can also 
# optionally add a public IP address for Internet-facing applications and 
# demo environments like this one.
resource "azurerm_public_ip" "servers-pip" {
  count               = var.servers
 name                = "${var.demo_prefix}-servers-ip-${count.index}"
  location            = var.location
 resource_group_name = azurerm_resource_group.demostack.name
  allocation_method   = "Static"
  domain_name_label   = "${var.hostname}-servers-${count.index}"
  sku                 = "Standard"

  tags = {
    name      =var.owner
    TTL       = var.TTL
    owner     = var.owner
    demostack = var.consul_join_tag_value
 }
}

resource "azurerm_virtual_machine" "servers" {
  depends_on = ["data.template_file.servers","data.template_cloudinit_config.servers"]
  count               = var.servers
 name                = "${var.hostname}-servers-${count.index}"
  location            = var.location
 resource_group_name = azurerm_resource_group.demostack.name
  vm_size             = var.vm_size
 availability_set_id = azurerm_availability_set.vm.id

  network_interface_ids         = [azurerm_network_interface.servers-nic[count.index].id]
  delete_os_disk_on_termination = "true"
  delete_data_disks_on_termination = "true"

  storage_image_reference {
    publisher = var.image_publisher
   offer     =  var.image_offer
   sku       =  var.image_sku
   version   =  var.image_version
 }

  storage_os_disk {
    name              = "${var.hostname}-sever-osdisk-${count.index}"
    managed_disk_type = "Standard_LRS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    disk_size_gb      = var.storage_disk_size
  }

   storage_data_disk {
    name = "${var.hostname}-sever-datadisk-${count.index}"
    caching = "ReadWrite"
    create_option = "Empty"
    disk_size_gb = 120
    lun = "10"
    managed_disk_type =  "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.hostname}-servers-${count.index}"
    admin_username = var.admin_username
    admin_password = var.admin_password
    ////////////////////////////////////////// 
       
        custom_data = "${element(data.template_cloudinit_config.servers[*].rendered, count.index)}" // this doesnt pass plan
       
    //////////////////////////////////////////     
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
