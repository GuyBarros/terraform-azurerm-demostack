

resource "azurerm_resource_group" "demostack" {
  name     = "${var.resource_group}"
  location = "${var.location}"

    tags {
    name  = "Guy Barros"
    ttl   = "13"
    owner = "guy@hashicorp.com"
    demostack = "${local.consul_join_tag_value}"
  }

}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.virtual_network_name}"
  location            = "${azurerm_resource_group.demostack.location}"
  address_space       = ["${var.address_space}"]
  resource_group_name = "${azurerm_resource_group.demostack.name}"

    tags {
    name  = "Guy Barros"
    ttl   = "13"
    owner = "guy@hashicorp.com"
    demostack = "${local.consul_join_tag_value}"
  }

}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.demo_prefix}subnet"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  resource_group_name  = "${azurerm_resource_group.demostack.name}"
  address_prefix       = "${var.subnet_prefix}"


}

resource "azurerm_network_security_group" "demostack-sg" {
  name                = "${var.demo_prefix}-sg"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.demostack.name}"


    tags {
    name  = "Guy Barros"
    ttl   = "13"
    owner = "guy@hashicorp.com"
    demostack = "${local.consul_join_tag_value}"
  }

  security_rule {
    name                       = "demostack-https"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "demostack-setup"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8800"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SSH"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 103
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "demostack-run"
    priority                   = 104
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8000-8800"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

    security_rule {
    name                       = "demostack-nodejs"
    priority                   = 105
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

    security_rule {
    name                       = "demostack-web"
    priority                   = 106
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3000-4999"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}


resource "azurerm_key_vault" "vaultkms" {
  name                        = "vaultkms"
  location                    = "${var.location}"
  resource_group_name         = "${azurerm_resource_group.demostack.name}"
  enabled_for_disk_encryption = true
  tenant_id                   = "${var.tenant}"

  sku {
    name = "standard"
  }




    tags {
    name  = "Guy Barros"
    ttl   = "13"
    owner = "guy@hashicorp.com"
    demostack = "${local.consul_join_tag_value}"
  }

}


resource "random_id" "keyvault" {
  byte_length = 4
}

resource "azurerm_key_vault" "demostack" {
  name                        = "demostack-${random_id.keyvault.hex}"
  location                    = "${azurerm_resource_group.demostack.location}"
  resource_group_name         = "${azurerm_resource_group.demostack.name}"
  enabled_for_deployment      = true
  enabled_for_disk_encryption = true
  tenant_id                   = "${var.tenant}"

  sku {
    name = "standard"
  }

  tags {
    name  = "Guy Barros"
    ttl   = "13"
    owner = "guy@hashicorp.com"
    demostack = "${local.consul_join_tag_value}"
  }
}

resource "azurerm_user_assigned_identity" "demostack" {
  resource_group_name = "${azurerm_resource_group.demostack.name}"
  location            = "${azurerm_resource_group.demostack.location}"

  name = "demostack-vm-identity"
}

resource "azurerm_key_vault_access_policy" "demostack_vm" {
  vault_name          = "${azurerm_key_vault.demostack.name}"
  resource_group_name = "${azurerm_key_vault.demostack.resource_group_name}"

  tenant_id = "${var.tenant}"
  object_id = "${azurerm_user_assigned_identity.demostack.client_id}"

  certificate_permissions = [
    "get",
  ]

  key_permissions = [
    "get",
  ]

  secret_permissions = [
    "get",
  ]
}



/*

//First Test, this code is crap. do not use
resource "azurerm_key_vault_access_policy" "vaultkmspolicy" {
  vault_name           = "${azurerm_key_vault.vaultkms.name}"
  resource_group_name  = "${azurerm_key_vault.vaultkms.resource_group_name}"

    count     = "${var.servers}"
    tenant_id = "${var.tenant}"
    object_id = "${element(azurerm_virtual_machine.demostack.*.id, count.index)}"

    key_permissions = [
      "backup",
      "create",
      "decrypt",
      "delete",
      "encrypt",
      "get",
      "import",
      "list",
      "purge",
      "recover",
      "restore",
      "sign",
      "unwrapKey",
      "update",
      "verify",
      "wrapKey",
    ]

    secret_permissions = [
      "backup",
      "delete",
      "get",
      "list",
      "purge",
      "recover",
      "restore",
      "set",
    ]


  network_acls {
    default_action             = "Deny"
    bypass                     = "None"
    virtual_network_subnet_ids = ["${azurerm_subnet.subnet.id}"]
  }
}
*/

/* 
resource "azurerm_key_vault_key" "vault-key" {
  name      = "vault-key"
  vault_uri = "${azurerm_key_vault.vaultkms.vault_uri}"
  key_type  = "RSA"
  key_size  = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}

*/