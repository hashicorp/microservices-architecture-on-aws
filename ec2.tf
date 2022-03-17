data "aws_ssm_parameter" "ubuntu1804" {
  name = "/aws/service/canonical/ubuntu/server/18.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
}

resource "aws_instance" "database" {
  ami                    = data.aws_ssm_parameter.ubuntu1804.value
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private[0].id
  vpc_security_group_ids = [aws_security_group.database.id]
  private_ip             = var.database_private_ip
  key_name               = var.ec2_key_pair
  tags                   = { "Name" = "${var.default_tags.project}-database" }

  user_data = base64encode(templatefile("${path.module}/scripts/database.sh", {
    DATABASE_SERVICE_NAME = var.database_service_name
    DATABASE_MESSAGE      = var.database_message
  }))
}