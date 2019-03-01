data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "demostack" {
  name     = "${var.resource_group}"
  location = "${var.location}"

  tags {
    name      = "Guy Barros"
    ttl       = "13"
    owner     = "guy@hashicorp.com"
    demostack = "${local.consul_join_tag_value}"
  }
}

resource "azurerm_availability_set" "vm" {
  # count                          = "${var.servers}"
  name                         = "${var.demo_prefix}-aval-set"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.demostack.name}"
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true

  tags {
    name      = "Guy Barros"
    ttl       = "13"
    owner     = "guy@hashicorp.com"
    demostack = "${local.consul_join_tag_value}"
  }
}




resource "azurerm_virtual_network" "awg" {
  name                = "${var.virtual_network_name}-awg"
  location            = "${azurerm_resource_group.demostack.location}"
  address_space       = ["${var.address_space}"]
  resource_group_name = "${azurerm_resource_group.demostack.name}"

  tags {
    name      = "Guy Barros"
    ttl       = "13"
    owner     = "guy@hashicorp.com"
    demostack = "${local.consul_join_tag_value}"
  }
}

resource "azurerm_subnet" "vault-awg" {
  name                 = "${var.demo_prefix}-vault-awg"
  virtual_network_name = "${azurerm_virtual_network.awg.name}"
  resource_group_name  = "${azurerm_resource_group.demostack.name}"
  address_prefix       = "10.0.10.0/24"
}

resource "azurerm_subnet" "fabio-awg" {
  name                 = "${var.demo_prefix}-fabio-awg"
  virtual_network_name = "${azurerm_virtual_network.awg.name}"
  resource_group_name  = "${azurerm_resource_group.demostack.name}"
  address_prefix       = "10.0.20.0/24"
}
resource "azurerm_subnet" "servers" {
  name                 = "${var.demo_prefix}-servers"
  virtual_network_name = "${azurerm_virtual_network.awg.name}"
  resource_group_name  = "${azurerm_resource_group.demostack.name}"
  address_prefix       = "10.0.30.0/24"
}

resource "azurerm_subnet" "workers" {
  name                 = "${var.demo_prefix}-workers"
  virtual_network_name = "${azurerm_virtual_network.awg.name}"
  resource_group_name  = "${azurerm_resource_group.demostack.name}"
  address_prefix       = "10.0.40.0/24"
}



resource "azurerm_public_ip" "vault-awg" {
  count               = 1
  name                = "${var.resource_group}-vault-awg"
  resource_group_name = "${azurerm_resource_group.demostack.name}"
  location            = "${var.location}"
  allocation_method   = "Dynamic"
  domain_name_label   = "${var.hostname}-vault-awg-${count.index}"
  sku                 = "Basic"

  tags {
    name      = "Guy Barros"
    ttl       = "13"
    owner     = "guy@hashicorp.com"
    demostack = "${local.consul_join_tag_value}"
  }
}

resource "azurerm_public_ip" "fabio-awg" {
  count               = 1
  name                = "${var.resource_group}-fabio-awg"
  resource_group_name = "${azurerm_resource_group.demostack.name}"
  location            = "${var.location}"
  allocation_method   = "Dynamic"
  domain_name_label   = "${var.hostname}-fabio-awg-${count.index}"
  sku                 = "Basic"

  tags {
    name      = "Guy Barros"
    ttl       = "13"
    owner     = "guy@hashicorp.com"
    demostack = "${local.consul_join_tag_value}"
  }
}





resource "azurerm_network_security_group" "demostack-sg" {
  name                = "${var.demo_prefix}-sg"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.demostack.name}"

  tags {
    name      = "Guy Barros"
    ttl       = "13"
    owner     = "guy@hashicorp.com"
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
    name                       = "demostack-ssh"
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
    name                       = "demostack-http"
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
    name                       = "demostack-consulandvault"
    priority                   = 104
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8000-8999"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "demostack-fabio"
    priority                   = 105
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9998-9999"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "demostack-nomad"
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
