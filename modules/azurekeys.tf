

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
    name      = "Guy Barros"
    ttl       = "13"
    owner     = "guy@hashicorp.com"
    demostack = "${local.consul_join_tag_value}"
  }
}

resource "azurerm_user_assigned_identity" "demostack" {
  resource_group_name = "${azurerm_resource_group.demostack.name}"
  location            = "${azurerm_resource_group.demostack.location}"

  name = "${var.hostname}-demostack-vm"
}

resource "azurerm_key_vault_access_policy" "demostack_vm" {
  vault_name          = "${azurerm_key_vault.demostack.name}"
  resource_group_name = "${azurerm_key_vault.demostack.resource_group_name}"

  tenant_id = "${var.tenant}"

  # object_id = "${azurerm_user_assigned_identity.demostack.principal_id}"
  object_id = "${var.client_id}"

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
