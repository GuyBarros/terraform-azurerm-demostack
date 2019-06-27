[0m[1mRefreshing Terraform state in-memory prior to plan...[0m
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.
[0m
[0m[1mmodule.primarycluster.random_id.keyvaultkey: Refreshing state... [id=CNbQeA][0m
[0m[1mmodule.primarycluster.random_id.keyvault: Refreshing state... [id=t0hQUQ][0m
[0m[1mmodule.primarycluster.data.azurerm_client_config.current: Refreshing state...[0m
[0m[1mmodule.primarycluster.azurerm_resource_group.demostack: Refreshing state... [id=/subscriptions/14692f20-9428-451b-8298-102ed4e39c2a/resourceGroups/demostack][0m
[0m[1mmodule.primarycluster.azurerm_key_vault.demostack: Refreshing state... [id=/subscriptions/14692f20-9428-451b-8298-102ed4e39c2a/resourceGroups/demostack/providers/Microsoft.KeyVault/vaults/demostack-b7485051][0m
[0m[1mmodule.primarycluster.azurerm_key_vault_key.demostack: Refreshing state... [id=https://demostack-b7485051.vault.azure.net/keys/demostack-08d6d078/5335de34d89e4accaf15bf7639944cf6][0m


Error: Error in function call

  on modules/server.tf line 172, in resource "azurerm_virtual_machine" "servers":
 172:         custom_data = "${element(data.template_cloudinit_config.servers[*].rendered, count.index)}" // this doesnt pass plan
    |----------------
    | count.index is 2
    | data.template_cloudinit_config.servers is empty tuple

Call to function "element" failed: cannot use element function with an empty
list.


Error: Error in function call

  on modules/server.tf line 172, in resource "azurerm_virtual_machine" "servers":
 172:         custom_data = "${element(data.template_cloudinit_config.servers[*].rendered, count.index)}" // this doesnt pass plan
    |----------------
    | count.index is 1
    | data.template_cloudinit_config.servers is empty tuple

Call to function "element" failed: cannot use element function with an empty
list.


Error: Error in function call

  on modules/server.tf line 172, in resource "azurerm_virtual_machine" "servers":
 172:         custom_data = "${element(data.template_cloudinit_config.servers[*].rendered, count.index)}" // this doesnt pass plan
    |----------------
    | count.index is 0
    | data.template_cloudinit_config.servers is empty tuple

Call to function "element" failed: cannot use element function with an empty
list.
