# User Facing Client Service
resource "aws_ecs_service" "client" {
  name            = "${var.default_tags.project}-client"
  cluster         = aws_ecs_cluster.main.arn
  task_definition = aws_ecs_task_definition.client.arn
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
    security_groups = [aws_security_group.ecs_client_service.id]
  }
}

resource "aws_ecs_service" "fruits" {
  name            = "${var.default_tags.project}-fruits"
  cluster         = aws_ecs_cluster.main.arn
  task_definition = aws_ecs_task_definition.fruits.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.fruits_alb_targets.arn
    container_name   = "fruits"
    container_port   = 9090
  }

  network_configuration {
    subnets          = aws_subnet.private.*.id
    assign_public_ip = false
    # defaults to the default VPC security group which allows all traffic from itself and all outbound traffic
    # instead, we define our own for each ECS service!
    security_groups = [aws_security_group.ecs_fruits_service.id]
  }
}