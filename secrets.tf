# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

resource "random_id" "consul_gossip_key" {
  byte_length = 32
}

resource "random_uuid" "consul_bootstrap_token" {

}