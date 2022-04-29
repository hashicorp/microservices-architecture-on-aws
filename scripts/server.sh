#!/bin/bash

# Install Consul.  This verifies the download via GPG and then creates...
# 1 - a default /etc/consul.d/consul.hcl
# 2 - a default systemd consul.service file
curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
apt update && apt install -y consul=1.11.4

# Make directory for certs
mkdir /etc/consul.d/certs

cat > /etc/consul.d/certs/consul-agent-ca.pem <<- EOF
${CA_PUBLIC_KEY}
EOF

cat > /etc/consul.d/certs/consul-server-cert.pem <<- EOF
${CONSUL_SERVER_PUBLIC_KEY}
EOF

cat > /etc/consul.d/certs/consul-server-key.pem <<- EOF
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
ca_file = "/etc/consul.d/certs/consul-agent-ca.pem"
# public certificate of the server
cert_file = "/etc/consul.d/certs/consul-server-cert.pem"
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
verify_incoming = true
verify_outgoing = true
verify_server_hostname = true
EOF

# Start Consul
systemctl start consul