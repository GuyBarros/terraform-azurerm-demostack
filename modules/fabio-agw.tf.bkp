resource "azurerm_application_gateway" "fabio-awg" {
  name                = "${var.resource_group}-fabio-awg"
  resource_group_name = "${azurerm_resource_group.demostack.name}"
  location            = "${var.location}"

  sku {
    name     = "Standard_Medium"
    tier     = "Standard"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "fabio-gateway-ip"
    subnet_id = "${azurerm_virtual_network.awg.id}/subnets/${azurerm_subnet.fabio-awg.name}"
  }

  frontend_port {
    name = "fabio-gateway-http"
    port = 9999
  }

  frontend_ip_configuration {
    name                 = "fabio-frontend-ip"
    public_ip_address_id = "${azurerm_public_ip.fabio-awg.id}"
    
  }

  backend_address_pool {
    name = "fabio-pool"
  }

  http_listener {
    name                           = "fabio-listener"
    frontend_ip_configuration_name = "fabio-frontend-ip"
    frontend_port_name             = "fabio-gateway-http"
    protocol                       = "Http"
    
  }

/*
  probe {
    name                = "fabio-health"
    protocol            = "http"
    path                = "/health"
    host                = "127.0.0.1"
    interval            = "30"
    timeout             = "30"
    unhealthy_threshold = "3"
  }
  */

  backend_http_settings {
    name                  = "fabio-backend"
    cookie_based_affinity = "Disabled"
    port                  = 9999
    protocol              = "Http"
    request_timeout       = 1
    // probe_name            = "fabio-health"

  }


  request_routing_rule {
    name                       = "fabio-routing"
    rule_type                  = "Basic"
    http_listener_name         = "fabio-listener"
    backend_address_pool_name  = "fabio-pool"
    backend_http_settings_name = "fabio-backend"
  }





}
