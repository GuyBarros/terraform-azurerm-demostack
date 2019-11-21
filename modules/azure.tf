provider "azurerm" {
  subscription_id        = var.subscription_id
 tenant_id              = var.tenant_id
 client_id           = var.client_id
 client_secret       = var.client_secret
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "demostack" {
  name     = var.resource_group
 location = var.location

  tags = {
    name      =var.owner
    TTL       = var.TTL
    owner     = var.owner
    demostack = var.consul_join_tag_value
 }
}

resource "azurerm_availability_set" "vm" {
  # count                          = var.servers
 name                         = "${var.demo_prefix}-aval-set"
  location                     = var.location
 resource_group_name          = azurerm_resource_group.demostack.name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true

  tags = {
    name      =var.owner
    TTL       = var.TTL
    owner     = var.owner
    demostack = var.consul_join_tag_value
 }
}




resource "azurerm_virtual_network" "awg" {
  name                = "${var.virtual_network_name}-awg"
  location            = azurerm_resource_group.demostack.location
  address_space       = ["${var.address_space}"]
  resource_group_name = azurerm_resource_group.demostack.name

  tags = {
    name      =var.owner
    TTL       = var.TTL
    owner     = var.owner
    demostack = var.consul_join_tag_value
 }
}

resource "azurerm_network_security_group" "demostack-sg" {
  name                = "${var.demo_prefix}-sg"
  location            = var.location
 resource_group_name = azurerm_resource_group.demostack.name

  tags = {
    name      =var.owner
    TTL       = var.TTL
    owner     = var.owner
    demostack = var.consul_join_tag_value
 }
# SSH
  security_rule {
    name                       = "demostack-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
# HTTP
  security_rule {
    name                       = "demostack-http"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

# HTTPS
  security_rule {
    name                       = "demostack-https"
    priority                   = 103
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

#LDAP
  security_rule {
    name                       = "demostack-LDAP"
    priority                   = 104
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

#Grafana
  security_rule {
    name                       = "demostack-grafana"
    priority                   = 105
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  #Postgres + pgadmin
  security_rule {
    name                       = "demostack-chat"
    priority                   = 106
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5000 - 5500"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "demostack-consulandvault"
    priority                   = 107
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8000-9200"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "demostack-fabio"
    priority                   = 108
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
    priority                   = 109
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3000-4999"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "demostack-envoy"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "19000-39999"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
