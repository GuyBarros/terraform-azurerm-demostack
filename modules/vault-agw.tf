resource "azurerm_application_gateway" "demostack" {
  name                = "${var.resource_group}-awg"
  resource_group_name = "${azurerm_resource_group.demostack.name}"
  location            = "${var.location}"

  sku {
    name     = "Standard"
    tier     = "Standard"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "subnet"
    subnet_id = "${azurerm_virtual_network.awg.id}/subnets/${azurerm_subnet.awg.name}"
  }

  frontend_port {
    name = "vault"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "frontend"
    public_ip_address_id = "${azurerm_public_ip.awg.id}"
  }

  backend_address_pool {
    # name = "${azurerm_lb_backend_address_pool.lb.name}"
    name = "demostack-backend-pool"
  }

  http_listener {
    name                           = "vault-ui"
    frontend_ip_configuration_name = "frontend"
    frontend_port_name             = "vault"
    protocol                       = "Http"
  }

  probe {
    name                = "probe"
    protocol            = "https"
    path                = "/v1/sys/health"
    host                = "127.0.0.1"
    interval            = "30"
    timeout             = "30"
    unhealthy_threshold = "3"
  }

  backend_http_settings {
    name                  = "vault-ui"
    cookie_based_affinity = "Disabled"
    port                  = 8200
    protocol              = "Https"
    request_timeout       = 1
    probe_name            = "vault-health"
  }

  request_routing_rule {
    name                       = "vault-ui"
    rule_type                  = "Basic"
    http_listener_name         = "vault-ui"
    backend_address_pool_name  = "demostack-backend-pool"
    backend_http_settings_name = "vault-ui"
  }
}

resource "azurerm_public_ip" "awg" {
  count               = 1
  name                = "${var.resource_group}-awg"
  resource_group_name = "${azurerm_resource_group.demostack.name}"
  location            = "${var.location}"
  allocation_method   = "Static"
  domain_name_label   = "${var.hostname}-awg-${count.index}"
  sku                 = "Standard"

  tags {
    name      = "Guy Barros"
    ttl       = "13"
    owner     = "guy@hashicorp.com"
    demostack = "${local.consul_join_tag_value}"
  }
}


resource "azurerm_subnet" "awg" {
  name                 = "${var.demo_prefix}-awg"
  virtual_network_name = "${azurerm_virtual_network.awg.name}"
  resource_group_name  = "${azurerm_resource_group.demostack.name}"
  address_prefix       = "10.0.10.0/24"
}

## this is a test
resource "azurerm_subnet" "servers" {
  name                 = "${var.demo_prefix}-servers"
  virtual_network_name = "${azurerm_virtual_network.awg.name}"
  resource_group_name  = "${azurerm_resource_group.demostack.name}"
  address_prefix       = "10.0.20.0/24"
}
#testing



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

/*
resource "azurerm_lb_backend_address_pool" "lb" {
  name                = "${var.resource_group}-bck-pool"
  resource_group_name = "${azurerm_resource_group.demostack.name}"
  loadbalancer_id     = "${azurerm_lb.lb.id}"
}
*/

