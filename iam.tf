# Consul Instance Role
resource "aws_iam_role" "consul_instance" {
  name_prefix        = "${var.aws_default_tags.Project}-role-"
  assume_role_policy = data.aws_iam_policy_document.instance_trust_policy.json
}

## Consul Instance Trust Policy
data "aws_iam_policy_document" "instance_trust_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = [
      "sts:AssumeRole"
    ]
  }
}

## Consul Instance Permissions Policy
data "aws_iam_policy_document" "instance_permissions_policy" {
  statement {
    sid    = "DescribeInstances" # change this to describe instances...
    effect = "Allow"
    actions = [
      "ec2:DescribeInstances"
    ]
    resources = [
      "*"
    ]
  }
}

## Consul Instance Role <> Policy Attachment
resource "aws_iam_role_policy" "consul_instance_policy" {
  name_prefix = "${var.aws_default_tags.Project}-instance-policy-"
  role        = aws_iam_role.consul_instance.id
  policy      = data.aws_iam_policy_document.instance_permissions_policy.json
}

## Consul Instance Profile <> Role Attachment
resource "aws_iam_instance_profile" "consul_instance_profile" {
  name_prefix = "${var.aws_default_tags.Project}-instance-profile-"
  role        = aws_iam_role.consul_instance.name
}