#!/bin/bash

CA_PUBLIC_KEY_LOCATION="/etc/consul.d/certs/consul-agent-ca.pem"
CONSUL_SERVER_PUBLIC_KEY_LOCATION="/etc/consul.d/certs/consul-server-cert.pem"
CONSUL_SERVER_PRIVATE_KEY_LOCATION="/etc/consul.d/certs/consul-server-key.pem"
CONSUL_VERSION="1.11.4"

# Install Consul.  This verifies the download via GPG and then creates...
# 1 - a default /etc/consul.d/consul.hcl
# 2 - a default systemd consul.service file
curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
apt update && apt install -y consul=$${CONSUL_VERSION}

# Make directory for certs
mkdir /etc/consul.d/certs

cat > $${CA_PUBLIC_KEY_LOCATION} <<- EOF
${CA_PUBLIC_KEY}
EOF

cat > $${CONSUL_SERVER_PUBLIC_KEY_LOCATION} <<- EOF
${CONSUL_SERVER_PUBLIC_KEY}
EOF

cat > $${CONSUL_SERVER_PRIVATE_KEY_LOCATION} <<- EOF
${CONSUL_SERVER_PRIVATE_KEY}
EOF

cat > /etc/consul.d/consul.hcl <<- EOF
# Enable the ACL system for Consul
acl = {
  enabled = true
  default_policy = "deny" # everything denied by default
  enable_token_persistence = true
  tokens = {
    master = "${CONSUL_BOOTSTRAP_TOKEN}" # used to bootstrap the system
    agent = "${CONSUL_BOOTSTRAP_TOKEN}" # used for agent operations https://www.consul.io/docs/security/acl/acl-tokens#acl-agent-token
  }
}
# Enable automatic distribution of TLS certificates to clients
auto_encrypt {
  allow_tls = true
}
# for internal communication between all nodes
bind_addr = "0.0.0.0"
# for incoming clients and servers connecting to the HTTP, HTTPS, and gRPC api
client_addr = "0.0.0.0"
# number of servers to wait for until bootstrapping
bootstrap_expect=${CONSUL_SERVER_COUNT}
# root certificate authority public cert to verify signatures
ca_file = $${CA_PUBLIC_KEY_LOCATION}
# public certificate of the server
cert_file = $${CONSUL_SERVER_PUBLIC_KEY_LOCATION}
# enable "Connect" which is Consul's Service Mesh
connect {
  enabled = true
}
# name of the datacenter, should be kept consistent
datacenter = "${CONSUL_SERVER_DATACENTER}"
# where consul stores its data
data_dir = "/opt/consul"
# the 32byte key for Gossip encryption - uses AES Galois/Counter Mode (GCM)
encrypt = "${CONSUL_GOSSIP_KEY}"
# private key for the server
key_file = "/etc/consul.d/certs/consul-server-key.pem"
# how the consul nodes will go about joining each other
retry_join = ["provider=aws tag_key=\"${AUTO_JOIN_TAG}\" tag_value=\"${AUTO_JOIN_TAG_VALUE}\""]
# whether this consul agent is a server or client
server = true
# if the UI is available
ui_config {
  enabled = true
}
# https://www.consul.io/docs/security/encryption#rpc-encryption-with-tls
# these are false for now because this is in beta - to be improved in the future
verify_incoming = false
verify_outgoing = false
verify_server_hostname = false

ports {
  http = 8500
  https = 8501
}

# Extra configurations to load up on bootstrap.  We're going to create intentions instead of having to do it via UI.
config_entries {
  bootstrap = [
    {
      kind = "proxy-defaults"
      name = "global"
      config {
        protocol = "http"
      }
    },
    {
      Kind = "service-intentions"
      Name = "${SERVICE_NAME_PREFIX}-fruits"
      Sources = [
        {
          Name = "${SERVICE_NAME_PREFIX}-client"
          Action = "allow"
        }
      ]
    },
    {
      Kind = "service-intentions"
      Name = "${SERVICE_NAME_PREFIX}-vegetables"
      Sources = [
        {
          Name = "${SERVICE_NAME_PREFIX}-client"
          Action = "allow"
        }
      ]
    }
  ]
}
EOF

# Start Consul
systemctl start consul

# Enable Consul to start on instance restart
systemctl enable consul
