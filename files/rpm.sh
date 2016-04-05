#!/bin/bash

#user set variables here for use in the rest of the mani
PUPPET_MASTER='yourpuppetmaster'
PP_INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
PP_IMAGE_NAME=$(curl -s http://169.254.169.254/latest/meta-data/ami-id)
PP_REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/.$//')

#create the CSR Attributes file before installing the agent
if [ ! -d /etc/puppetlabs/puppet ]; then
    mkdir -p /etc/puppetlabs/puppet
fi

# Until PUP-5535 is live, we use the OID for pp_region

cat > /etc/puppetlabs/puppet/csr_attributes.yaml << YAML
extension_requests:
  pp_instance_id: $PP_INSTANCE_ID
  pp_image_name: $PP_IMAGE_NAME
  1.3.6.1.4.1.34380.1.1.18: $PP_REGION
YAML

curl -sk https://$PUPPET_MASTER:8140/packages/current/install.bash | /bin/bash -s agent:certname=$PP_INSTANCE_ID
