# User Facing Client Service
resource "aws_ecs_service" "client" {
  name            = "${local.project_tag}-client"
  cluster         = aws_ecs_cluster.main.arn
  task_definition = module.client.task_definition_arn
  desired_count   = 1
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.client_alb_targets.arn
    container_name   = "client"
    container_port   = 9090
  }

  network_configuration {
    subnets          = aws_subnet.private.*.id
    assign_public_ip = false
    # defaults to the default VPC security group which allows all traffic from itself and all outbound traffic
    # instead, we define our own for each ECS service!
    security_groups = [aws_security_group.ecs_client_service.id, aws_security_group.consul_client.id]
  }

  propagate_tags = "TASK_DEFINITION"
}

resource "aws_ecs_service" "fruits" {
  name            = "${local.project_tag}-fruits"
  cluster         = aws_ecs_cluster.main.arn
  task_definition = module.fruits.task_definition_arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.private.*.id
    assign_public_ip = false
    # defaults to the default VPC security group which allows all traffic from itself and all outbound traffic
    # instead, we define our own for each ECS service!
    security_groups = [aws_security_group.ecs_fruits_service.id, aws_security_group.consul_client.id]
  }

  propagate_tags = "TASK_DEFINITION"
}

resource "aws_ecs_service" "fruits_v2" {
  name            = "${local.project_tag}-fruits-v2"
  cluster         = aws_ecs_cluster.main.arn
  task_definition = module.fruits_v2.task_definition_arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.private.*.id
    assign_public_ip = false
    security_groups = [aws_security_group.ecs_fruits_service.id, aws_security_group.consul_client.id]
  }

  propagate_tags = "TASK_DEFINITION"
}

resource "aws_ecs_service" "vegetables" {
  name            = "${local.project_tag}-vegetables"
  cluster         = aws_ecs_cluster.main.arn
  task_definition = module.vegetables.task_definition_arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.private.*.id
    assign_public_ip = false
    # defaults to the default VPC security group which allows all traffic from itself and all outbound traffic
    # instead, we define our own for each ECS service!
    security_groups = [aws_security_group.ecs_vegetables_service.id, aws_security_group.consul_client.id]
  }

  propagate_tags = "TASK_DEFINITION"
}

module "consul_acl_controller" {
  source  = "hashicorp/consul-ecs/aws//modules/acl-controller"
  version = "0.4.1"

  name_prefix     = local.project_tag
  ecs_cluster_arn = aws_ecs_cluster.main.arn
  region          = var.region

  consul_bootstrap_token_secret_arn = aws_secretsmanager_secret.consul_bootstrap_token.arn
  consul_server_ca_cert_arn         = aws_secretsmanager_secret.consul_root_ca_cert.arn

  # Point to a singular server IP.  Even if its not the leader, the request will be forwarded appropriately
  # this keeps us from using the public facing load balancer
  consul_server_http_addr = "https://${local.server_private_ips[0]}:8501"

  # the ACL controller module creates the required IAM role to allow logging
  log_configuration = local.acl_logs_configuration

  # mapped to an underlying `aws_ecs_service` resource, so its the same format
  security_groups = [aws_security_group.acl_controller.id, aws_security_group.consul_client.id]

  # mapped to an underlying `aws_ecs_service` resource, so its the same format
  subnets = aws_subnet.private.*.id

  depends_on = [
    aws_nat_gateway.nat,
    aws_instance.consul_server # https://github.com/hashicorp/terraform/issues/15285 should work, dsepite count
  ]
}