# User Facing Client Task Definition
# --
# This is the container that will serve as the entry point for public facing traffic
resource "aws_ecs_task_definition" "client" {
  family                   = "${var.default_tags.project}-client"
  requires_compatibilities = ["FARGATE"]
  # required for Fargate launch type
  memory       = 512
  cpu          = 256
  network_mode = "awsvpc"

  container_definitions = jsonencode([
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

      # Fake Service settings are set via Environment variables
      environment = [
        {
          name  = "NAME"
          value = "client"
        },
        {
          name  = "MESSAGE"
          value = "Hello from the client!"
        }
      ]
    }
  ])
}