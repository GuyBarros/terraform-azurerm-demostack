resource "azurerm_application_gateway" "vault-awg" {
  name                = "${var.resource_group}vault-awg"
  resource_group_name = "${azurerm_resource_group.demostack.name}"
  location            = "${var.location}"

  sku {
    name     = "Standard_Medium"
    tier     = "Standard"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "vault-gateway-ip"
    subnet_id = "${azurerm_virtual_network.awg.id}/subnets/${azurerm_subnet.vault-awg.name}"
  }

  frontend_port {
    name = "vault-gateway-http"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "vault-frontend-ip"
    public_ip_address_id = "${azurerm_public_ip.vault-awg.id}"
    
  }

  backend_address_pool {
    name = "vault-pool"
  }

  http_listener {
    name                           = "vault-listener"
    frontend_ip_configuration_name = "vault-frontend-ip"
    frontend_port_name             = "vault-gateway-http"
    protocol                       = "Http"
    
  }

  probe {
    name                = "vault-health"
    protocol            = "https"
    path                = "/v1/sys/health"
    host                = "127.0.0.1"
    interval            = "30"
    timeout             = "30"
    unhealthy_threshold = "3"
  }

authentication_certificate{
 name = "server-0"
 data = "${tls_locally_signed_cert.servers.0.cert_pem}"
}
authentication_certificate{
 name = "server-1"
 data = "${tls_locally_signed_cert.servers.1.cert_pem}"
}
authentication_certificate{
 name = "server-2"
 data = "${tls_locally_signed_cert.servers.2.cert_pem}"
}

  backend_http_settings {
    name                  = "vault-backend"
    cookie_based_affinity = "Disabled"
    port                  = 8200
    protocol              = "Https"
    request_timeout       = 1
    probe_name            = "vault-health"
    authentication_certificate{
       name = "server-0"
    }
    authentication_certificate{
       name = "server-1"
    }
    authentication_certificate{
       name = "server-2"
    }


  }


  request_routing_rule {
    name                       = "vault-routing"
    rule_type                  = "Basic"
    http_listener_name         = "vault-listener"
    backend_address_pool_name  = "vault-pool"
    backend_http_settings_name = "vault-backend"
  }





}
