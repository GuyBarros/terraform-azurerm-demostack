write-host "Creating Hashicorp Packages Directory"
New-Item -ItemType directory -Path C:\Hashicorp_packages\
write-host "Configuring Firewall Rules for Consul and Nomad"
New-NetFirewallRule -Name "ConsulTCP" -DisplayName "Consult TCP ports (8000-9000)" -Profile Domain,Private,Public -Enabled True -Protocol TCP -LocalPort 8000-9000 -Action Allow
New-NetFirewallRule -Name "ConsulUDP" -DisplayName "Consult UDP ports (8000-9000)" -Profile Domain,Private,Public -Enabled True -Protocol UDP -LocalPort 8000-9000 -Action Allow
New-NetFirewallRule -Name "NomadTCP" -DisplayName "Nomad TCP ports (4000-5000)" -Profile Domain,Private,Public -Enabled True -Protocol TCP -LocalPort 4000-5000 -Action Allow
New-NetFirewallRule -Name "NomadUDP" -DisplayName "Nomad UDP ports (4000-5000)" -Profile Domain,Private,Public -Enabled True -Protocol UDP -LocalPort 4000-5000 -Action Allow 
write-host "Downloading Hashicorp Binaries"
Import-Module BitsTransfer
Start-BitsTransfer -Source https://releases.hashicorp.com/consul/1.4.4+ent/consul_1.4.4+ent_windows_amd64.zip -Destination C:\Hashicorp_packages\consul_1.4.4+ent_windows_amd64.zip
Start-BitsTransfer -Source https://releases.hashicorp.com/nomad/0.9.0/nomad_0.9.0_windows_amd64.zip -Destination C:\Hashicorp_packages\nomad_0.9.0_windows_amd64.zip
write-host "Expanding Hashicorp Binaries"
Expand-Archive C:\Hashicorp_packages\consul_1.4.4+ent_windows_amd64.zip -DestinationPath C:\Hashicorp\Consul\
Expand-Archive C:\Hashicorp_packages\nomad_0.9.0_windows_amd64.zip -DestinationPath C:\Hashicorp\Nomad\
write-host "Creating Consul Service"
sc.exe create "Hashicorp Consul" binPath= "C:\Hashicorp\Consul\consul.exe agent -config-file=C:\Hashicorp\Consul\config.json" start= auto
write-host "Creating Nomad Service"
sc.exe create "Hashicorp Nomad" binPath= "C:\Hashicorp\Nomad\nomad.exe agent -config=C:\Hashicorp\Nomad\config.json" start= auto
write-host "waiting for 45 seconds while the downloads finish"
Start-Sleep -Seconds 45
write-host "Starting Consul Service"
sc.exe start "Consul" 

write-host "Starting Consul Service"
sc.exe start "Nomad" 