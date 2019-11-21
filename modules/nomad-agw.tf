resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "nomad-servers-awg" {
  count                   = var.servers
 network_interface_id    =  "${azurerm_network_interface.servers-nic[count.index].id}"
  ip_configuration_name   = "${var.demo_prefix}-${count.index}-ipconfig"
  backend_address_pool_id = azurerm_application_gateway.nomad-awg.backend_address_pool.0.id
}


resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "nomad-workers-awg" {
  count                   = var.workers
 network_interface_id    = "${azurerm_network_interface.workers-nic[count.index].id}"
  ip_configuration_name   = "${var.demo_prefix}-${count.index}-ipconfig"
  backend_address_pool_id = azurerm_application_gateway.nomad-awg.backend_address_pool.0.id
}


resource "azurerm_subnet" "nomad-awg" {
  name                 = "${var.demo_prefix}-nomad-awg"
  virtual_network_name = azurerm_virtual_network.awg.name
  resource_group_name  = azurerm_resource_group.demostack.name
  address_prefix       = "10.0.50.0/24"
}

resource "azurerm_public_ip" "nomad-awg" {
  name                = "${var.resource_group}-nomad-awg"
  resource_group_name = azurerm_resource_group.demostack.name
  location            = var.location
 allocation_method   = "Dynamic"
  domain_name_label   = "${var.hostname}-nomad-awg-pip"
  sku                 = "Basic"

  tags = {
    name      =var.owner
    TTL       = var.TTL
    owner     = var.owner
    demostack = var.consul_join_tag_value
 }
}

resource "azurerm_application_gateway" "nomad-awg" {
  name                = "${var.resource_group}nomad-awg"
  resource_group_name = azurerm_resource_group.demostack.name
  location            = var.location

  sku {
    name     = "Standard_Medium"
    tier     = "Standard"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "nomad-gateway-ip"
    subnet_id = "${azurerm_virtual_network.awg.id}/subnets/${azurerm_subnet.nomad-awg.name}"
  }

  frontend_port {
    name = "nomad-gateway-http"
    port = 4646
  }

  frontend_ip_configuration {
    name                 = "nomad-frontend-ip"
    public_ip_address_id = azurerm_public_ip.nomad-awg.id
    
  }

  backend_address_pool {
    name = "nomad-pool"
  }

  http_listener {
    name                           = "nomad-listener"
    frontend_ip_configuration_name = "nomad-frontend-ip"
    frontend_port_name             = "nomad-gateway-http"
    protocol                       = "Http"
    
  }

  probe {
    name                = "nomad-health"
    protocol            = "https"
    path                = "/v1/sys/health"
    host                = "127.0.0.1"
    interval            = "30"
    timeout             = "30"
    unhealthy_threshold = "3"
  }

authentication_certificate{
 name = "server-0"
 data = tls_locally_signed_cert.servers.0.cert_pem
}
authentication_certificate{
 name = "server-1"
 data = tls_locally_signed_cert.servers.1.cert_pem
 }
authentication_certificate{
 name = "server-2"
 data = tls_locally_signed_cert.servers.2.cert_pem
}
authentication_certificate{
 name = "worker-0"
 data = tls_locally_signed_cert.workers.0.cert_pem
}
authentication_certificate{
 name = "worker-1"
 data = tls_locally_signed_cert.workers.1.cert_pem
}
authentication_certificate{
 name = "worker-2"
 data = tls_locally_signed_cert.workers.2.cert_pem
}

  backend_http_settings {
    name                  = "nomad-backend"
    cookie_based_affinity = "Disabled"
    port                  = 4646
    protocol              = "Https"
    request_timeout       = 1
    probe_name            = "nomad-health"
    authentication_certificate{
       name = "server-0"
    }
    authentication_certificate{
       name = "server-1"
    }
    authentication_certificate{
       name = "server-2"
    }
    authentication_certificate{
       name = "worker-0"
    }
    authentication_certificate{
       name = "worker-1"
    }
    authentication_certificate{
       name = "worker-2"
    }


  }


  request_routing_rule {
    name                       = "nomad-routing"
    rule_type                  = "Basic"
    http_listener_name         = "nomad-listener"
    backend_address_pool_name  = "nomad-pool"
    backend_http_settings_name = "nomad-backend"
  }





}
