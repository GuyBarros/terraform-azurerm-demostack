resource "azurerm_managed_disk" "demostack_csi_datadisk" {
  name = "${var.hostname}-csi-datadisk"
  location            = var.location
 resource_group_name = azurerm_resource_group.demostack.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1"

  tags = {
    name      =var.owner
    TTL       = var.TTL
    owner     = var.owner
    demostack = var.consul_join_tag_value
 }
}