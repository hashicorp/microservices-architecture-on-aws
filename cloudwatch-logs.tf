resource "aws_cloudwatch_log_group" "client" {
  name = "${var.default_tags.project}-client-logs"
}

resource "aws_cloudwatch_log_group" "client_sidecars" {
  name = "${var.default_tags.project}-client-sidecars-logs"
}

resource "aws_cloudwatch_log_group" "fruits" {
  name = "${var.default_tags.project}-fruits-logs"
}

resource "aws_cloudwatch_log_group" "fruits_sidecars" {
  name = "${var.default_tags.project}-fruits-sidecars-logs"
}

resource "aws_cloudwatch_log_group" "vegetables" {
  name = "${var.default_tags.project}-vegetables-logs"
}

resource "aws_cloudwatch_log_group" "vegetables_sidecars" {
  name = "${var.default_tags.project}-vegetables-sidecars-logs"
}

resource "aws_cloudwatch_log_group" "acl" {
  name = "${var.default_tags.project}-acl-logs"
}

locals {
  acl_logs_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = aws_cloudwatch_log_group.acl.name
      awslogs-region        = var.region
      awslogs-stream-prefix = "${var.default_tags.project}-acl-"
    }
  }
  client_logs_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = aws_cloudwatch_log_group.client.name
      awslogs-region        = var.region
      awslogs-stream-prefix = "${var.default_tags.project}-client"
    }
  }
  client_sidecars_log_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = aws_cloudwatch_log_group.client_sidecars.name
      awslogs-region        = var.region
      awslogs-stream-prefix = "${var.default_tags.project}-client-sidecars-"
    }
  }
  fruits_log_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = aws_cloudwatch_log_group.fruits.name
      awslogs-region        = var.region
      awslogs-stream-prefix = "${var.default_tags.project}-fruits"
    }
  }
  fruits_sidecars_log_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = aws_cloudwatch_log_group.fruits_sidecars.name
      awslogs-region        = var.region
      awslogs-stream-prefix = "${var.default_tags.project}-fruits-sidecars-"
    }
  }
  vegetables_log_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = aws_cloudwatch_log_group.vegetables.name
      awslogs-region        = var.region
      awslogs-stream-prefix = "${var.default_tags.project}-vegetables"
    }
  }
  vegetables_sidecars_log_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = aws_cloudwatch_log_group.vegetables_sidecars.name
      awslogs-region        = var.region
      awslogs-stream-prefix = "${var.default_tags.project}-vegetables-sidecars-"
    }
  }
}