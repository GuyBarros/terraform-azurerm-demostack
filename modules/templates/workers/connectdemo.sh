#!/usr/bin/env bash
set -e

echo "==> Starting Nomad jobs"

#!/usr/bin/env bash
set -e

echo "--> cloning  Nomad Job"
sudo mkdir /demostack
 cd /demostack
 sudo git clone https://github.com/GuyBarros/nomad_jobs
sleep 10

echo "--> Running  Nomad Jobs"
nomad run /demostack/nomad_jobs/hashibo.nomad
nomad run /demostack/nomad_jobs/nginx-pki.nomad
nomad run /demostack/nomad_jobs/orchestrators.nomad

echo "==>Running nomad jobs is Done!"


