##############################################################################
# Variables File
# 
# Here is where we store the default values for all the variables used in our
# Terraform code. If you create a variable with no default, the user will be
# prompted to enter it (or define it via config file or command line flags.)

variable "resource_group" {
  description = "The name of your Azure Resource Group."
  default     = "Azure-Consul-Demo"
}

variable "demo_prefix" {
  description = "This prefix will be included in the name of some resources."
  default     = "demostack"
}

variable "hostname" {
  description = "VM hostname. Used for local hostname, DNS, and storage-related names."
  default     = "demostack"
}

variable "location" {
  description = "The region where the virtual network is created."
  default     = "centralus"
}

variable "virtual_network_name" {
  description = "The name for your virtual network."
  default     = "vnet"
}

variable "address_space" {
  description = "The address space that is used by the virtual network. You can supply more than one address space. Changing this forces a new resource to be created."
  default     = "10.0.0.0/16"
}

variable "subnet_prefix" {
  description = "The address prefix to use for the subnet."
  default     = "10.0.10.0/24"
}

variable "storage_account_tier" {
  description = "Defines the storage tier. Valid options are Standard and Premium."
  default     = "Standard"
}

variable "storage_disk_size" {
  description = "Defines the OS disk size. minimum is 70"
  default     = "100"
}

variable "storage_replication_type" {
  description = "Defines the replication type to use for this storage account. Valid options include LRS, GRS etc."
  default     = "LRS"
}

variable "vm_size" {
  description = "Specifies the size of the virtual machine."
  default     = "Standard_D4_v3"
}

variable "image_publisher" {
  description = "Name of the publisher of the image (az vm image list)"
  default     = "Canonical"
}

variable "image_offer" {
  description = "Name of the offer (az vm image list)"
  default     = "UbuntuServer"
}

variable "image_sku" {
  description = "Image SKU to apply (az vm image list)"
  default     = "16.04-LTS"
}

variable "image_version" {
  description = "Version of the image to apply (az vm image list)"
  default     = "latest"
}

variable "admin_username" {
  description = "Administrator user name"
  default     = "admin"
}

variable "admin_password" {
  description = "Administrator password"
  default     = "replace-with-your-password"
}

variable "servers" {
  description = "Ammount of Consul Instances to be created"
  default     = 3
}

variable "workers" {
  description = "Ammount of Nomad workers to be created"
  default     = 3
}

variable "consul_url" {
  description = "The url to download Consul."
  default     = "https://releases.hashicorp.com/consul/1.2.2/consul_1.2.2_linux_amd64.zip"
}

variable "consul_ent_url" {
  description = "The url to download Consul."
  default     = "https://releases.hashicorp.com/consul/1.2.2/consul_1.2.2_linux_amd64.zip"
}

variable "packer_url" {
  description = "The url to download Packer."
  default     = "https://releases.hashicorp.com/packer/1.2.5/packer_1.2.5_linux_amd64.zip"
}

variable "sentinel_url" {
  description = "The url to download Sentinel simulator."
  default     = "https://releases.hashicorp.com/sentinel/0.3.0/sentinel_0.3.0_linux_amd64.zip"
}

variable "consul_template_url" {
  description = "The url to download Consul Template."
  default     = "https://releases.hashicorp.com/consul-template/0.19.5/consul-template_0.19.5_linux_amd64.zip"
}

variable "envconsul_url" {
  description = "The url to download Envconsul."
  default     = "https://releases.hashicorp.com/envconsul/0.7.3/envconsul_0.7.3_linux_amd64.zip"
}

variable "fabio_url" {
  description = "The url download fabio."
  default     = "https://github.com/fabiolb/fabio/releases/download/v1.5.7/fabio-1.5.7-go1.9.2-linux_amd64"
}

variable "hashiui_url" {
  description = "The url to download hashi-ui."
  default     = "https://github.com/jippi/hashi-ui/releases/download/v0.26.1/hashi-ui-linux-amd64"
}

variable "nomad_url" {
  description = "The url to download nomad."
  default     = "https://releases.hashicorp.com/nomad/0.8.6/nomad_0.8.6_linux_amd64.zip"
}

variable "nomad_ent_url" {
  description = "The url to download nomad."
  default     = "https://releases.hashicorp.com/nomad/0.8.6/nomad_0.8.6_linux_amd64.zip"
}

variable "terraform_url" {
  description = "The url to download terraform."
  default     = "https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip"
}

variable "vault_url" {
  description = "The url to download vault."
  default     = "https://releases.hashicorp.com/vault/0.11.1/vault_0.11.1_linux_amd64.zip"
}

variable "vault_ent_url" {
  description = "The url to download vault."
  default     = "https://s3-us-west-2.amazonaws.com/hc-enterprise-binaries/vault/ent/0.11.1/vault-enterprise_0.11.1%2Bent_linux_amd64.zip"
}

variable "primarynamespace" {
  description = <<EOH
The primary namespace 
EOH

  default = "primaryconnectdemo"
}

variable "secondarynamespace" {
  description = <<EOH
The secondary namespace
EOH

  default = "secondaryconnectdemo"
}

variable "owner" {
  description = "IAM user responsible for lifecycle of cloud resources used for training"
}

variable "created-by" {
  description = "Tag used to identify resources created programmatically by Terraform"
  default     = "Terraform"
}

variable "sleep-at-night" {
  description = "Tag used by reaper to identify resources that can be shutdown at night"
  default     = true
}

variable "TTL" {
  description = "Hours after which resource expires, used by reaper. Do not use any unit. -1 is infinite."
  default     = "240"
}

variable "demo_username" {
  description = "The username to attach to the user demo login as."
  default     = "demo"
}

variable "demo_password" {
  description = "The password to attach to the user demo login as."
  default     = "demo"
}

variable "public_key" {
  description = "The contents of the SSH public key to use for connecting to the cluster."
}

variable "enterprise" {
  description = "do you want to use the enterprise version of the binaries"
  default     = false
}

variable "subscription" {
  description = "your subscription ID for Vault KMS Auto Unseal"
}

variable "tenant" {
  description = "your tenant ID for Vault KMS Auto Unseal"
}

variable "client_id" {
  description = "your client ID for Vault KMS Auto Unseal"
}

variable "client_secret" {
  description = "your client ID for Vault KMS Auto Unseal"
}

variable "vaultlicense" {
  description = "Enterprise License for Vault"
  default     = ""
}

variable "consullicense" {
  description = "Enterprise License for Consul"
  default     = ""
}

variable "namespace" {
  description = "Enterprise License for Consul"
  default     = "demostack"
}

locals {
  consul_join_tag_value = "${var.hostname}-${random_id.consul_join_tag_value.hex}"

  consul_join_tag_name = "demostack"
}

variable "ca_key_algorithm" {
  default = ""
}

variable "ca_private_key_pem" {
  default = ""
}

variable "ca_cert_pem" {
  default = ""
}
