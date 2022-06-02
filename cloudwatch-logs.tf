resource "aws_cloudwatch_log_group" "client" {
  name_prefix = "${local.project_tag}-client-"
}

resource "aws_cloudwatch_log_group" "client_sidecars" {
  name_prefix = "${local.project_tag}-client-sidecars-"
}

resource "aws_cloudwatch_log_group" "fruits" {
  name_prefix = "${local.project_tag}-fruits-"
}

resource "aws_cloudwatch_log_group" "fruits_sidecars" {
  name_prefix = "${local.project_tag}-fruits-sidecars-"
}

resource "aws_cloudwatch_log_group" "fruits_v2" {
  name_prefix = "${local.project_tag}-fruits-v2-"
}

resource "aws_cloudwatch_log_group" "fruits_v2_sidecars" {
  name_prefix = "${local.project_tag}-fruits-v2-sidecars-"
}

resource "aws_cloudwatch_log_group" "vegetables" {
  name_prefix = "${local.project_tag}-vegetables-"
}

resource "aws_cloudwatch_log_group" "vegetables_sidecars" {
  name_prefix = "${local.project_tag}-vegetables-sidecars-"
}

resource "aws_cloudwatch_log_group" "acl" {
  name_prefix = "${local.project_tag}-acl-"
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
      awslogs-stream-prefix = "${local.project_tag}-client-"
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
      awslogs-stream-prefix = "${local.project_tag}-fruits-"
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
  fruits_v2_log_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = aws_cloudwatch_log_group.fruits_v2.name
      awslogs-region        = var.region
      awslogs-stream-prefix = "${local.project_tag}-fruits-v2-"
    }
  }
  fruits_v2_sidecars_log_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = aws_cloudwatch_log_group.fruits_v2_sidecars.name
      awslogs-region        = var.region
      awslogs-stream-prefix = "${local.project_tag}-fruits-v2-sidecars-"
    }
  }
  vegetables_log_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = aws_cloudwatch_log_group.vegetables.name
      awslogs-region        = var.region
      awslogs-stream-prefix = "${local.project_tag}-vegetables-"
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