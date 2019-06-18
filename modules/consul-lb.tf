

# Create Public IP Address for the Load Balancer
resource "azurerm_public_ip" "consul-lb-pip" {
  name                = "${var.resource_group}-consul-lb-pip"
  resource_group_name = "${azurerm_resource_group.demostack.name}"
  location            = "${var.location}"
  allocation_method   = "Static"
  domain_name_label   = "${var.hostname}-consul-lb"
  sku                 = "Standard"

  tags = {
    name      = "Guy Barros"
    ttl       = "13"
    owner     = "guy@hashicorp.com"
    demostack = "${var.consul_join_tag_value}"
  }
}

# create and configure Azure Load Balancer

resource "azurerm_lb" "consul-lb" {
  name                = "${var.resource_group}-consul-lb"
  resource_group_name = "${azurerm_resource_group.demostack.name}"
  location            = "${var.location}"
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "${var.resource_group}-consulpip"
    public_ip_address_id = "${azurerm_public_ip.consul-lb-pip.id}"
  }

  tags = {
    name      = "Guy Barros"
    ttl       = "13"
    owner     = "guy@hashicorp.com"
    demostack = "${var.consul_join_tag_value}"
  }
}

resource "azurerm_lb_probe" "consul-lb-probe" {
  name                = "${var.resource_group}-consul-lb-probe"
  resource_group_name = "${azurerm_resource_group.demostack.name}"
  loadbalancer_id     = "${azurerm_lb.consul-lb.id}"
  protocol            = "http"
  port                = "8500"
  request_path        = "/v1/status/leader"
  number_of_probes    = "1"
}

resource "azurerm_lb_rule" "consul-lb-rule" {
  name                           = "${var.resource_group}-consul-lb-rule"
  resource_group_name            = "${azurerm_resource_group.demostack.name}"
  loadbalancer_id                = "${azurerm_lb.consul-lb.id}"
  protocol                       = "Tcp"
  frontend_port                  = "8500"
  backend_port                   = "8500"
  frontend_ip_configuration_name = "${azurerm_lb.consul-lb.frontend_ip_configuration.0.name}"
  probe_id                       = "${azurerm_lb_probe.consul-lb-probe.id}"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.consul-lb-pool.id}"
  depends_on                     = ["azurerm_public_ip.consul-lb-pip","azurerm_lb_probe.consul-lb-probe", "azurerm_lb_backend_address_pool.consul-lb-pool"]
}
################################################

resource "azurerm_lb_probe" "fabio-lb-probe" {
  name                = "${var.resource_group}-fabio-lb-probe"
  resource_group_name = "${azurerm_resource_group.demostack.name}"
  loadbalancer_id     = "${azurerm_lb.consul-lb.id}"
  protocol            = "http"
  port                = "9998"
  request_path        = "/health"
  number_of_probes    = "1"
}

resource "azurerm_lb_rule" "fabio-lb-rule" {
  name                           = "${var.resource_group}-fabio-lb-rule"
  resource_group_name            = "${azurerm_resource_group.demostack.name}"
  loadbalancer_id                = "${azurerm_lb.consul-lb.id}"
  protocol                       = "Tcp"
  frontend_port                  = "9999"
  backend_port                   = "9999"
  frontend_ip_configuration_name = "${azurerm_lb.consul-lb.frontend_ip_configuration.0.name}"
  probe_id                       = "${azurerm_lb_probe.consul-lb-probe.id}"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.consul-lb-pool.id}"
  depends_on                     = ["azurerm_public_ip.consul-lb-pip","azurerm_lb_probe.consul-lb-probe", "azurerm_lb_backend_address_pool.consul-lb-pool"]
}
########################


resource "azurerm_lb_backend_address_pool" "consul-lb-pool" {
  name                = "${var.resource_group}-consul-lb-pool"
  resource_group_name = "${azurerm_resource_group.demostack.name}"
  loadbalancer_id     = "${azurerm_lb.consul-lb.id}"
}

resource "azurerm_network_interface_backend_address_pool_association" "consul-lb-servers" {
  count                   = "${var.servers}"
  network_interface_id    = "${azurerm_network_interface.servers-nic[count.index].id}"
  ip_configuration_name   = "${var.demo_prefix}-${count.index}-ipconfig"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.consul-lb-pool.id }"
}


resource "azurerm_network_interface_backend_address_pool_association" "consul-lb-workers" {
  count                   = "${var.workers}"
  network_interface_id    = "${azurerm_network_interface.workers-nic[count.index].id}"
  ip_configuration_name   = "${var.demo_prefix}-${count.index}-ipconfig"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.consul-lb-pool.id }"
}