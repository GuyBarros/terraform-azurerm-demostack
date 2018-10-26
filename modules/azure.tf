

resource "azurerm_resource_group" "consul_demo" {
  name     = "${var.resource_group}"
  location = "${var.location}"
/*
    tags {
    name  = "Guy Barros"
    ttl   = "13"
    owner = "guy@hashicorp.com"
    ConsulDemo = "${local.consul_join_tag_value}"
  }
*/
}

# The next resource is a Virtual Network. We can dynamically place it into the
# resource group without knowing its name ahead of time. Terraform handles all
# of that for you, so everything is named consistently every time. Say goodbye
# to weirdly-named mystery resources in your Azure Portal. To see how all this
# works visually, run `terraform graph` and copy the output into the online
# GraphViz tool: http://www.webgraphviz.com/
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.virtual_network_name}"
  location            = "${azurerm_resource_group.consul_demo.location}"
  address_space       = ["${var.address_space}"]
  resource_group_name = "${azurerm_resource_group.consul_demo.name}"
/*
    tags {
    name  = "Guy Barros"
    ttl   = "13"
    owner = "guy@hashicorp.com"
    ConsulDemo = "${local.consul_join_tag_value}"
  }
*/
}

# Next we'll build a subnet to run our VMs in. These variables can be defined 
# via environment variables, a config file, or command line flags. Default 
# values will be used if the user does not override them. You can find all the
# default variables in the variables.tf file. You can customize this demo by
# making a copy of the terraform.tfvars.example file.
resource "azurerm_subnet" "subnet" {
  name                 = "${var.demo_prefix}subnet"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  resource_group_name  = "${azurerm_resource_group.consul_demo.name}"
  address_prefix       = "${var.subnet_prefix}"
/*
    tags {
    name  = "Guy Barros"
    ttl   = "13"
    owner = "guy@hashicorp.com"
    ConsulDemo = "${local.consul_join_tag_value}"
  }
*/
}

##############################################################################
# HashiCorp consuldemo Server
#
# Now that we have a network, we'll deploy a stand-alone HashiCorp consuldemo 
# server. consuldemo supports a 'dev' mode which is appropriate for demonstrations
# and development purposes. In other words, don't do this in production.

# An Azure Virtual Machine has several components. In this example we'll build
# a security group, a network interface, a public ip address, a storage 
# account and finally the VM itself. Terraform handles all the dependencies 
# automatically, and each resource is named with user-defined variables.

# Security group to allow inbound access on port 8200 and 22
resource "azurerm_network_security_group" "consuldemo-sg" {
  name                = "${var.demo_prefix}-sg"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.consul_demo.name}"

/*
    tags {
    name  = "Guy Barros"
    ttl   = "13"
    owner = "guy@hashicorp.com"
    ConsulDemo = "${local.consul_join_tag_value}"
  }
*/
  security_rule {
    name                       = "consuldemo-https"
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
    name                       = "consuldemo-setup"
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
    name                       = "consuldemo-run"
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
    name                       = "consuldemo-nodejs"
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
    name                       = "consuldemo-web"
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

# A network interface. This is required by the azurerm_virtual_machine 
# resource. Terraform will let you know if you're missing a dependency.


resource "azurerm_key_vault" "vaultkms" {
  name                        = "vaultkms"
  location                    = "${var.location}"
  resource_group_name         = "${azurerm_resource_group.consul_demo.name}"
  enabled_for_disk_encryption = true
  tenant_id                   = "${var.tenant}"

  sku {
    name = "standard"
  }



/*
    tags {
    name  = "Guy Barros"
    ttl   = "13"
    owner = "guy@hashicorp.com"
    ConsulDemo = "${local.consul_join_tag_value}"
  }
*/
}
/*
resource "azurerm_key_vault_access_policy" "vaultkmspolicy" {
  vault_name           = "${azurerm_key_vault.vaultkms.name}"
  resource_group_name  = "${azurerm_key_vault.vaultkms.resource_group_name}"

    count     = "${var.server}"
    tenant_id = "${var.tenant}"
    object_id = "${element(azurerm_virtual_machine.consuldemo.*.id, count.index)}"

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