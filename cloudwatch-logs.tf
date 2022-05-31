resource "aws_cloudwatch_log_group" "client" {
  name = "${local.project_tag}-client-logs"
}

resource "aws_cloudwatch_log_group" "client_sidecars" {
  name = "${local.project_tag}-client-sidecars-logs"
}

resource "aws_cloudwatch_log_group" "fruits" {
  name = "${local.project_tag}-fruits-logs"
}

resource "aws_cloudwatch_log_group" "fruits_sidecars" {
  name = "${local.project_tag}-fruits-sidecars-logs"
}

resource "aws_cloudwatch_log_group" "vegetables" {
  name = "${local.project_tag}-vegetables-logs"
}

resource "aws_cloudwatch_log_group" "vegetables_sidecars" {
  name = "${local.project_tag}-vegetables-sidecars-logs"
}

resource "aws_cloudwatch_log_group" "acl" {
  name = "${local.project_tag}-acl-logs"
}

locals {
  acl_logs_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = aws_cloudwatch_log_group.acl.name
      awslogs-region        = var.region
      awslogs-stream-prefix = "${local.project_tag}-acl-"
    }
  }
  client_logs_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = aws_cloudwatch_log_group.client.name
      awslogs-region        = var.region
      awslogs-stream-prefix = "${local.project_tag}-client"
    }
  }
  client_sidecars_log_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = aws_cloudwatch_log_group.client_sidecars.name
      awslogs-region        = var.region
      awslogs-stream-prefix = "${local.project_tag}-client-sidecars-"
    }
  }
  fruits_log_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = aws_cloudwatch_log_group.fruits.name
      awslogs-region        = var.region
      awslogs-stream-prefix = "${local.project_tag}-fruits"
    }
  }
  fruits_sidecars_log_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = aws_cloudwatch_log_group.fruits_sidecars.name
      awslogs-region        = var.region
      awslogs-stream-prefix = "${local.project_tag}-fruits-sidecars-"
    }
  }
  vegetables_log_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = aws_cloudwatch_log_group.vegetables.name
      awslogs-region        = var.region
      awslogs-stream-prefix = "${local.project_tag}-vegetables"
    }
  }
  vegetables_sidecars_log_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = aws_cloudwatch_log_group.vegetables_sidecars.name
      awslogs-region        = var.region
      awslogs-stream-prefix = "${local.project_tag}-vegetables-sidecars-"
    }
  }
}