
2019/06/20 21:53:07 [INFO] Terraform version: 0.12.2
2019/06/20 21:53:07 [INFO] Go runtime version: go1.12.4
2019/06/20 21:53:07 [INFO] CLI args: []string{"E:\\HashiCorp\\Terraform\\terraform.exe", "plan"}
2019/06/20 21:53:07 [DEBUG] Attempting to open CLI config file: C:\Users\phatb\AppData\Roaming\terraform.rc
2019/06/20 21:53:07 Loading CLI configuration from C:\Users\phatb\AppData\Roaming\terraform.rc
2019/06/20 21:53:07 [INFO] CLI command args: []string{"plan"}
2019/06/20 21:53:07 [TRACE] Meta.Backend: built configuration for "remote" backend with hash value 3114413150
2019/06/20 21:53:07 [TRACE] Preserving existing state lineage "287da814-393e-9617-2f97-7717bf1914ce"
2019/06/20 21:53:07 [TRACE] Preserving existing state lineage "287da814-393e-9617-2f97-7717bf1914ce"
2019/06/20 21:53:07 [TRACE] Meta.Backend: working directory was previously initialized for "remote" backend
2019/06/20 21:53:07 [TRACE] Meta.Backend: using already-initialized, unchanged "remote" backend configuration
2019/06/20 21:53:07 [DEBUG] Service discovery for app.terraform.io at https://app.terraform.io/.well-known/terraform.json
2019/06/20 21:53:08 [DEBUG] Retrieve version constraints for service tfe.v2.1 and product terraform
2019/06/20 21:53:09 [TRACE] Meta.Backend: instantiated backend of type *remote.Remote
2019/06/20 21:53:09 [DEBUG] checking for provider in "."
2019/06/20 21:53:09 [DEBUG] checking for provider in "E:\\HashiCorp\\Terraform"
2019/06/20 21:53:09 [DEBUG] checking for provider in ".terraform\\plugins\\windows_amd64"
2019/06/20 21:53:09 [DEBUG] found provider "terraform-provider-azurerm_v1.30.1_x4.exe"
2019/06/20 21:53:09 [DEBUG] found provider "terraform-provider-random_v2.1.2_x4.exe"
2019/06/20 21:53:09 [DEBUG] found provider "terraform-provider-template_v2.1.2_x4.exe"
2019/06/20 21:53:09 [DEBUG] found provider "terraform-provider-tls_v2.0.1_x4.exe"
2019/06/20 21:53:09 [DEBUG] found valid plugin: "tls", "2.0.1", "e:\\Dropbox\\GIT_ROOT\\terraform-azurerm-demostack\\.terraform\\plugins\\windows_amd64\\terraform-provider-tls_v2.0.1_x4.exe"
2019/06/20 21:53:09 [DEBUG] found valid plugin: "azurerm", "1.30.1", "e:\\Dropbox\\GIT_ROOT\\terraform-azurerm-demostack\\.terraform\\plugins\\windows_amd64\\terraform-provider-azurerm_v1.30.1_x4.exe"
2019/06/20 21:53:09 [DEBUG] found valid plugin: "random", "2.1.2", "e:\\Dropbox\\GIT_ROOT\\terraform-azurerm-demostack\\.terraform\\plugins\\windows_amd64\\terraform-provider-random_v2.1.2_x4.exe"
2019/06/20 21:53:09 [DEBUG] found valid plugin: "template", "2.1.2", "e:\\Dropbox\\GIT_ROOT\\terraform-azurerm-demostack\\.terraform\\plugins\\windows_amd64\\terraform-provider-template_v2.1.2_x4.exe"
2019/06/20 21:53:09 [DEBUG] checking for provisioner in "."
2019/06/20 21:53:09 [DEBUG] checking for provisioner in "E:\\HashiCorp\\Terraform"
2019/06/20 21:53:09 [DEBUG] checking for provisioner in ".terraform\\plugins\\windows_amd64"
2019/06/20 21:53:09 [TRACE] Meta.Backend: backend *remote.Remote supports operations
2019/06/20 21:53:10 [INFO] backend/remote: starting Plan operation
Running plan in the remote backend. Output will stream here. Pressing Ctrl-C
will stop streaming the logs, but will not stop the plan running remotely.

Preparing the remote plan...

To view this run in a browser, visit:
https://app.terraform.io/app/emea-se-playground-2019/Guy-Azure-Demostack/runs/run-yz5iMaULyeGEujxr

Waiting for the plan to start...

Terraform v0.12.2

Configuring remote state backend...
Initializing Terraform configuration...
2019/06/20 20:53:20 [DEBUG] Using modified User-Agent: Terraform/0.12.2 TFE/10c585e
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

data.terraform_remote_state.emea_se_playground_tls_root_certificate: Refreshing state...
module.primarycluster.data.azurerm_client_config.current: Refreshing state...

Error: Error in function call

  on modules/server.tf line 172, in resource "azurerm_virtual_machine" "servers":
 172:         custom_data = "${element(data.template_cloudinit_config.servers[*].rendered, count.index)}" // this doesnt pass plan
    |----------------
    | count.index is 0
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
    | count.index is 2
    | data.template_cloudinit_config.servers is empty tuple

Call to function "element" failed: cannot use element function with an empty
list.

