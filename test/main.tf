variable "location" {}
variable "environment" {}
variable "tenant_id" {}

resource "azurerm_resource_group" "tfe" {
  name     = "${var.environment}-tfe-security"
  location = "${var.location}"
}

resource "random_id" "keyvault" {
  byte_length = 4
}

resource "azurerm_key_vault" "keyvault" {
  name                        = "${var.environment}-tfe-${random_id.keyvault.hex}"
  location                    = "${azurerm_resource_group.tfe.location}"
  resource_group_name         = "${azurerm_resource_group.tfe.name}"
  enabled_for_deployment      = true
  enabled_for_disk_encryption = true
  tenant_id                   = "${var.tenant_id}"

  sku {
    name = "standard"
  }

  tags {
    environment = "${var.environment}"
  }
}

resource "azurerm_user_assigned_identity" "tfe" {
  resource_group_name = "${azurerm_resource_group.tfe.name}"
  location            = "${azurerm_resource_group.tfe.location}"

  name = "${var.environment}-tfe-vm"
}

resource "azurerm_key_vault_access_policy" "tfe_vm" {
  vault_name          = "${azurerm_key_vault.tfe.name}"
  resource_group_name = "${azurerm_key_vault.tfe.resource_group_name}"

  tenant_id = "${var.tenant_id}"
  object_id = "${azurerm_user_assigned_identity.tfe.principal_id}"

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

output "service_identity_principal_id" {
  value = "${azurerm_user_assigned_identity.tfe.principal_id}"
}

output "key_vault_name" {
  value = "${azurerm_key_vault.tfe.name}"
}
