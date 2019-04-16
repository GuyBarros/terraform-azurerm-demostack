name         = "${node_name}"
data_dir     = "C:\Hashicorp\Nomad\data\"
enable_debug = true

"bind_addr" = "0.0.0.0"


datacenter = "${location}"

region = "azure"

advertise {
  http = "${public_ip}:4646"
  rpc  = "${public_ip}:4647"
  serf = "${public_ip}:4648"
}
server {
  enabled          = true
  bootstrap_expect = ${nomad_servers}
  encrypt          = "${nomad_gossip_key}"
}

client {
  enabled = true
   options {
    "driver.raw_exec.enable" = "1"
  }
}

tls {
  rpc  = true
  http = true
  key_file = "C:\HashiCorp\certs\me.key"
  cert_file = "C:\HashiCorp\certs\me.crt"
  ca_file = "C:\HashiCorp\certs\01-me.crt"

  verify_server_hostname = false
}

vault {
  enabled          = true
  address          = "https://active.vault.service.consul:8200"
  key_file = "C:\HashiCorp\certs\me.key"
  cert_file = "C:\HashiCorp\certs\me.crt"
  ca_file = "C:\HashiCorp\certs\01-me.crt"
  create_from_role = "nomad-cluster"
}

autopilot {
    cleanup_dead_servers = true
    last_contact_threshold = "200ms"
    max_trailing_logs = 250
    server_stabilization_time = "10s"
    enable_redundancy_zones = false
    disable_upgrade_migration = false
    enable_custom_upgrades = false
}

