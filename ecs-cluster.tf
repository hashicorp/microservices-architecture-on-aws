# Copyright IBM Corp. 2022, 2026

resource "aws_ecs_cluster" "main" {
  name = local.project_tag
}