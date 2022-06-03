# User Facing Client Task Definition
# --
# This is the container that will serve as the entry point for public facing traffic
module "client" {
  source  = "hashicorp/consul-ecs/aws//modules/mesh-task"
  version = "0.4.1"

  family                   = "${local.project_tag}-client"
  requires_compatibilities = ["FARGATE"]
  # required for Fargate launch type
  memory = 512
  cpu    = 256

  container_definitions = [
    {
      name      = "client"
      image     = "nicholasjackson/fake-service:v0.23.1"
      cpu       = 0 # take up proportional cpu
      essential = true

      portMappings = [
        {
          containerPort = 9090
          hostPort      = 9090 # though, access to the ephemeral port range is needed to connect on EC2, the exact port is required on Fargate from a security group standpoint.
          protocol      = "tcp"
        }
      ]

      logConfiguration = local.client_logs_configuration

      # Fake Service settings are set via Environment variables
      environment = [
        {
          name  = "NAME"
          value = "client"
        },
        {
          name  = "MESSAGE"
          value = "Hello from the client!"
        },
        {
          name  = "UPSTREAM_URIS"
          value = "http://localhost:1234,http://localhost:1235"
        }
      ]
    }
  ]

  # All settings required by the mesh-task module
  acls                           = true
  acl_secret_name_prefix         = local.project_tag
  consul_datacenter              = var.consul_dc1_name
  consul_server_ca_cert_arn      = aws_secretsmanager_secret.consul_root_ca_cert.arn
  consul_client_token_secret_arn = module.consul_acl_controller.client_token_secret_arn
  gossip_key_secret_arn          = aws_secretsmanager_secret.consul_gossip_key.arn
  log_configuration              = local.client_sidecars_log_configuration

  # https://github.com/hashicorp/consul-ecs/blob/main/config/schema.json#L74#
  # to tell the proxy and consul-ecs how to contact the service
  port = "9090"

  tls = true

  # the consul-ecs binary takes a large configuration file: https://github.com/hashicorp/consul-ecs/blob/0817f073c665c3933e9455f477b18500616e7c47/config/schema.json
  # the variable "consul_ecs_config" lets you specify the entire thing
  # however, arguments such as "upstreams" (below) can be used instead to
  # target smaller parts of the config without specifying the entire thing: https://github.com/hashicorp/terraform-aws-consul-ecs/blob/3da977ed327ac9bf37a2083854152c2bb4e1ddac/modules/mesh-task/variables.tf#L303-L305
  upstreams = [
    {
      # Name of the CONSUL Service (not to be confused with the ECS Service)
      # This is specified by setting the "family" name for mesh task modules
      # The "family" will map both to the Consul Service and the ECS Task Definition
      # https://github.com/hashicorp/terraform-aws-consul-ecs/blob/main/modules/mesh-task/main.tf#L187
      # https://github.com/hashicorp/terraform-aws-consul-ecs/blob/v0.3.0/modules/mesh-task/variables.tf#L6-L10
      destinationName = "${local.project_tag}-fruits"
      # This is the port that requests to this service will be sent to, and, the port that the proxy will be
      # listening on LOCALLY.
      # https://github.com/hashicorp/consul-ecs/blob/0817f073c665c3933e9455f477b18500616e7c47/config/schema.json#L326
      # the above link is the value this maps to
      localBindPort = 1234
    },
    {
      # https://github.com/hashicorp/consul-ecs/blob/85755adb288055df92c1880d30f1861db771ca63/subcommand/mesh-init/command_test.go#L77
      # looks like upstreams need different local bind ports, which begs the question of what a localBindPort is even doing
      # I guess this is just what the service points to that the envoy listener goes through
      destinationName = "${local.project_tag}-vegetables"
      localBindPort   = 1235
    }
  ]
  # join on the private IPs, much like the consul config "retry_join" argument
  retry_join = local.server_private_ips

  depends_on = [
    module.consul_acl_controller
  ]

}

module "fruits" {
  source  = "hashicorp/consul-ecs/aws//modules/mesh-task"
  version = "0.4.1"

  family                   = "${local.project_tag}-fruits"
  requires_compatibilities = ["FARGATE"]
  # required for Fargate launch type
  memory = 512
  cpu    = 256

  container_definitions = [
    {
      name      = "fruits"
      image     = "nicholasjackson/fake-service:v0.23.1"
      cpu       = 0 # take up proportional cpu
      essential = true

      portMappings = [
        {
          containerPort = 9090
          hostPort      = 9090 # though, access to the ephemeral port range is needed to connect on EC2, the exact port is required on Fargate from a security group standpoint.
          protocol      = "tcp"
        }
      ]

      logConfiguration = local.fruits_log_configuration

      # Fake Service settings are set via Environment variables
      environment = [
        {
          name  = "NAME"
          value = "fruits"
        },
        {
          name  = "MESSAGE"
          value = "Hello from the fruits client!"
        },
        {
          name  = "UPSTREAM_URIS"
          value = "http://${var.database_private_ip}:27017"
        }
      ]
    }
  ]

  acls                           = true
  acl_secret_name_prefix         = local.project_tag
  consul_datacenter              = var.consul_dc1_name
  consul_server_ca_cert_arn      = aws_secretsmanager_secret.consul_root_ca_cert.arn
  consul_client_token_secret_arn = module.consul_acl_controller.client_token_secret_arn
  gossip_key_secret_arn          = aws_secretsmanager_secret.consul_gossip_key.arn
  port                           = "9090"
  log_configuration              = local.fruits_sidecars_log_configuration
  tls                            = true

  # isn't needed right now, because there is no "database" service that consul is aware of
  # upstreams = [
  #   {
  #     # this will not work at the moment, because our database
  #     # isn't set up with consul or registered as a service
  #     destinationName = "${var.aws_default_tags.Project}-database"
  #     localBindPort  = 1234
  #   }
  # ]
  retry_join = local.server_private_ips

  depends_on = [
    module.consul_acl_controller
  ]
}

module "fruits_v2" {
  source  = "hashicorp/consul-ecs/aws//modules/mesh-task"
  version = "0.4.1"

  family                   = "${local.project_tag}-fruits-v2"
  requires_compatibilities = ["FARGATE"]
  # required for Fargate launch type
  memory = 512
  cpu    = 256

  container_definitions = [
    {
      name      = "fruits"
      image     = "nicholasjackson/fake-service:v0.23.1"
      cpu       = 0 # take up proportional cpu
      essential = true

      portMappings = [
        {
          containerPort = 9090
          hostPort      = 9090 # though, access to the ephemeral port range is needed to connect on EC2, the exact port is required on Fargate from a security group standpoint.
          protocol      = "tcp"
        }
      ]

      logConfiguration = local.fruits_v2_log_configuration

      # Fake Service settings are set via Environment variables
      environment = [
        {
          name  = "NAME"
          value = "fruits"
        },
        {
          name  = "MESSAGE"
          value = "Hello from the fruits service version 2!"
        },
        {
          name  = "UPSTREAM_URIS"
          value = "http://${var.database_private_ip}:27017"
        }
      ]
    }
  ]

  acls                           = true
  acl_secret_name_prefix         = local.project_tag
  consul_datacenter              = var.consul_dc1_name
  consul_server_ca_cert_arn      = aws_secretsmanager_secret.consul_root_ca_cert.arn
  consul_client_token_secret_arn = module.consul_acl_controller.client_token_secret_arn
  gossip_key_secret_arn          = aws_secretsmanager_secret.consul_gossip_key.arn
  port                           = "9090"
  log_configuration              = local.fruits_v2_sidecars_log_configuration
  tls                            = true
  retry_join = local.server_private_ips
  depends_on = [
    module.consul_acl_controller
  ]
}

module "vegetables" {
  source  = "hashicorp/consul-ecs/aws//modules/mesh-task"
  version = "0.4.1"

  family                   = "${local.project_tag}-vegetables"
  requires_compatibilities = ["FARGATE"]
  # required for Fargate launch type
  memory = 512
  cpu    = 256

  container_definitions = [
    {
      name      = "vegetables"
      image     = "nicholasjackson/fake-service:v0.23.1"
      cpu       = 0 # take up proportional cpu
      essential = true

      portMappings = [
        {
          containerPort = 9090
          hostPort      = 9090 # though, access to the ephemeral port range is needed to connect on EC2, the exact port is required on Fargate from a security group standpoint.
          protocol      = "tcp"
        }
      ]

      logConfiguration = local.vegetables_log_configuration

      # Fake Service settings are set via Environment variables
      environment = [
        {
          name  = "NAME"
          value = "vegetables"
        },
        {
          name  = "MESSAGE"
          value = "Hello from the vegetables client!"
        },
        {
          name  = "UPSTREAM_URIS"
          value = "http://${var.database_private_ip}:27017"
        }
      ]
    }
  ]

  acls                           = true
  acl_secret_name_prefix         = local.project_tag
  consul_datacenter              = var.consul_dc1_name
  consul_server_ca_cert_arn      = aws_secretsmanager_secret.consul_root_ca_cert.arn
  consul_client_token_secret_arn = module.consul_acl_controller.client_token_secret_arn
  gossip_key_secret_arn          = aws_secretsmanager_secret.consul_gossip_key.arn
  log_configuration              = local.vegetables_sidecars_log_configuration
  port                           = "9090"
  tls                            = true
  # upstreams = [
  #   {
  #     # this will not work at the moment, because our database
  #     # isn't set up with consul or registered as a service
  #     destinationName = "${var.aws_default_tags.Project}-database"
  #     localBindPort  = 1234
  #   }
  # ]
  retry_join = local.server_private_ips

  depends_on = [
    module.consul_acl_controller
  ]
}