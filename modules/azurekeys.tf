resource "random_id" "keyvault" {
  byte_length = 4
}

resource "random_id" "keyvaultkey" {
  byte_length = 4
}

resource "azurerm_key_vault" "demostack" {
  name                        = "demostack-${random_id.keyvault.hex}"
  location                    = "${azurerm_resource_group.demostack.location}"
  resource_group_name         = "${azurerm_resource_group.demostack.name}"
  enabled_for_deployment      = true
  enabled_for_disk_encryption = true
  tenant_id                   = "${var.tenant_id}"

  sku {
    name = "standard"
  }

  tags {
    name      = "Guy Barros"
    ttl       = "13"
    owner     = "guy@hashicorp.com"
    demostack = "${var.consul_join_tag_value}"
  }
}

resource "azurerm_user_assigned_identity" "demostack" {
  resource_group_name = "${azurerm_resource_group.demostack.name}"
  location            = "${azurerm_resource_group.demostack.location}"

  name = "${var.hostname}-demostack-vm"
}

resource "azurerm_key_vault_access_policy" "demostack_vm" {
  key_vault_id = "${azurerm_key_vault.demostack.id}"

  # resource_group_name = "${azurerm_key_vault.demostack.resource_group_name}"

  # tenant_id = "${var.tenant}"
  #  object_id = "${azurerm_user_assigned_identity.demostack.principal_id}"
  tenant_id = "${data.azurerm_client_config.current.tenant_id}"
  object_id = "${data.azurerm_client_config.current.service_principal_object_id}"

  # object_id = "${var.client_id}"
  # application_id = "${var.client_id}"

  certificate_permissions = [
    "get",
    "list",
    "create",
    "delete",
    "import",
    "update",
    "managecontacts",
    "getissuers",
    "listissuers",
    "setissuers",
    "deleteissuers",
    "manageissuers",
    "recover",
    "purge",
    "backup",
    "restore",
  ]

  // -PermissionsToStorage get,list,delete,set,update,regeneratekey,getsas,listsas,deletesas,setsas,recover,backup,restore,purge 

  key_permissions = [
    "decrypt",
    "encrypt",
    "unwrapKey",
    "wrapKey",
    "verify",
    "sign",
    "get",
    "list",
    "update",
    "create",
    "import",
    "delete",
    "backup",
    "restore",
    "recover",
    "purge",
  ]
  secret_permissions = [
    "get",
    "list",
    "set",
    "delete",
    "backup",
    "restore",
    "recover",
    "purge",
  ]
}

resource "azurerm_key_vault_key" "demostack" {
  name         = "demostack-${random_id.keyvaultkey.hex}"
  key_vault_id = "${azurerm_key_vault.demostack.id}"
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]

  tags {
    name      = "Guy Barros"
    ttl       = "13"
    owner     = "guy@hashicorp.com"
    demostack = "${var.consul_join_tag_value}"
  }
}
