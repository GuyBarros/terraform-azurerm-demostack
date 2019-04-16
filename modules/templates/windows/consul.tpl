
  {
  "datacenter": "${location}",
  "acl_datacenter": "${location}",
  "acl_master_token": "${consul_master_token}",
  "acl_token": "${consul_master_token}",
  "acl_default_policy": "allow",
  "advertise_addr": "${private_ip}",
  "advertise_addr_wan": "${public_ip}",
  "bootstrap_expect": ${consul_servers},
  "bind_addr": "0.0.0.0",
  "node_name": "${node_name}",
  "data_dir": "C:\HashiCorp\Consul\data",  
  "encrypt": "${consul_gossip_key}",
  "disable_update_check": true,
  "leave_on_terminate": true,
  "raft_protocol": 3,
  "retry_join": ["provider=azure tag_name=${consul_join_tag_name}  tag_value=${consul_join_tag_value} tenant_id=${tenant_id} client_id=${client_id} subscription_id=${subscription_id} secret_access_key=${client_secret} "],

  "server": true,
  "addresses": {
    "http": "0.0.0.0",
    "https": "0.0.0.0"
  },
  "ports": {
    "http": 8500,
    "https": 8533
  },
  "key_file": "C:\HashiCorp\certs\me.key",
  "cert_file": "C:\HashiCorp\certs\me.crt",
  "ca_file": "C:\HashiCorp\certs\01-me.crt",
  "verify_incoming": false,
  "verify_outgoing": false,
  "verify_server_hostname": false,
  "ui": true,
  "autopilot": {
    "cleanup_dead_servers": true,
    "last_contact_threshold": "200ms",
    "max_trailing_logs": 250,
    "server_stabilization_time": "10s",
    "redundancy_zone_tag": "",
    "disable_upgrade_migration": false,
    "upgrade_version_tag": ""
},
 "connect":{
  "enabled": true,
      "proxy": {  "allow_managed_root": true  }
      }
}
 
  