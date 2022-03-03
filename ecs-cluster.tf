resource "aws_ecs_cluster" "main" {
  name = var.default_tags.project
}