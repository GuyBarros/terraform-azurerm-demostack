#!/usr/bin/env bash
echo "==> Disable UFW"
sudo systemctl stop ufw
sudo systemctl disable ufw

echo "==> Consul (server)"
if [ ${enterprise} == 0 ]
then
echo "--> Fetching OSS binaries"
install_from_url "consul" "${consul_url}"
else
echo "--> Fetching enterprise binaries"
install_from_url "consul" "${consul_ent_url}"
fi


echo "--> Writing configuration"
sudo mkdir -p /mnt/consul
sudo mkdir -p /etc/consul.d
sudo tee /etc/consul.d/config.json > /dev/null <<EOF
{
  "datacenter": "${location}",
  "primary_datacenter":  "${primary_datacenter}",
  "bootstrap_expect": ${consul_servers},
  "advertise_addr": "${private_ip}",
  "advertise_addr_wan": "${public_ip}",
  "bind_addr": "0.0.0.0",
  "client_addr": "0.0.0.0",
  "data_dir": "/mnt/consul",
  "encrypt": "${consul_gossip_key}",
  "leave_on_terminate": true,
  "node_name": "${node_name}",
  "retry_join": ["provider=azure tag_name=${consul_join_tag_name}  tag_value=${consul_join_tag_value} tenant_id=${tenant_id} client_id=${client_id} subscription_id=${subscription_id} secret_access_key=${client_secret} "],
  "server": true,
  "ports": {
    "http": 8500,
    "https": 8501,
    "grpc": 8502
  },
  "connect":{
    "enabled": true
  },
  "ui": true,
  "enable_central_service_config":true,
  "autopilot": {
    "cleanup_dead_servers": true,
    "last_contact_threshold": "200ms",
    "max_trailing_logs": 250,
    "server_stabilization_time": "10s",
    "disable_upgrade_migration": false
  },
  "telemetry": {
    "disable_hostname": true,
    "prometheus_retention_time": "30s"
  }
}
EOF


echo "--> Writing profile"
sudo tee /etc/profile.d/consul.sh > /dev/null <<"EOF"
alias conslu="consul"
alias ocnsul="consul"
EOF
source /etc/profile.d/consul.sh

echo "--> Generating systemd configuration"
sudo tee /etc/systemd/system/consul.service > /dev/null <<"EOF"
[Unit]
Description=Consul
Documentation=https://www.consul.io/docs/
Requires=network-online.target
After=network-online.target

[Service]
Restart=on-failure
ExecStart=/usr/local/bin/consul agent -config-dir="/etc/consul.d"
ExecReload=/bin/kill -HUP $MAINPID
KillSignal=SIGINT

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl enable consul
sudo systemctl restart consul

echo "--> Installing dnsmasq"

sudo tee /etc/dnsmasq.d/10-consul > /dev/null <<"EOF"
server=/consul/127.0.0.1#8600
no-poll
server=8.8.8.8
server=8.8.4.4
cache-size=0
EOF
sudo systemctl enable dnsmasq
sudo systemctl restart dnsmasq

echo "--> Waiting for all Consul servers"
while [ "$(consul members 2>&1 | grep "servers" | grep "alive" | wc -l)" -lt "${consul_servers}" ]; do
  sleep 3
done

echo "--> Waiting for Consul leader"
while [ -z "$(curl -s http://127.0.0.1:8500/v1/status/leader)" ]; do
  sleep 3
done

if [ ${enterprise} == 1 ]
then
sudo consul license put "${consullicense}" > /tmp/consullicense.out


fi


echo "--> Denying anonymous access to vault/ and tmp/"
curl -so /dev/null -X PUT http://127.0.0.1:8500/v1/acl/update \
  -H "X-Consul-Token: ${consul_master_token}" \
  -d @- <<BODY
{
  "ID": "anonymous",
  "Rules": "key \"vault\" { policy = \"deny\" }\n\nkey \"tmp\" { policy = \"deny\" }"
}
BODY

echo "==> Consul is done!"
