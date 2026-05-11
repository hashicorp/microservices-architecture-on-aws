# Copyright IBM Corp. 2022, 2026

resource "random_id" "consul_gossip_key" {
  byte_length = 32
}

resource "random_uuid" "consul_bootstrap_token" {

}