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
  tags                   = { "Name" = "${local.project_tag}-database" }

  user_data = base64encode(templatefile("${path.module}/scripts/database.sh", {
    DATABASE_SERVICE_NAME = var.database_service_name
    DATABASE_MESSAGE      = var.database_message
  }))

  depends_on = [aws_nat_gateway.nat]
}

resource "aws_instance" "consul_server" {
  count = var.consul_server_count

  ami                         = data.aws_ssm_parameter.ubuntu1804.value
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.private[count.index].id
  associate_public_ip_address = false
  key_name                    = var.ec2_key_pair

  vpc_security_group_ids = [aws_security_group.consul_server.id]
  private_ip             = local.server_private_ips[count.index]

  iam_instance_profile = aws_iam_instance_profile.consul_instance_profile.name

  tags = { "Name" = "${local.project_tag}-consul-server" }

  user_data = base64encode(templatefile("${path.module}/scripts/server.sh", {
    CA_PUBLIC_KEY             = tls_self_signed_cert.ca_cert.cert_pem
    CONSUL_SERVER_PUBLIC_KEY  = tls_locally_signed_cert.consul_server_signed_cert.cert_pem
    CONSUL_SERVER_PRIVATE_KEY = tls_private_key.consul_server_key.private_key_pem
    CONSUL_BOOTSTRAP_TOKEN    = random_uuid.consul_bootstrap_token.result
    CONSUL_GOSSIP_KEY         = random_id.consul_gossip_key.b64_std
    CONSUL_SERVER_COUNT       = var.consul_server_count
    CONSUL_SERVER_DATACENTER  = var.consul_dc1_name
    AUTO_JOIN_TAG             = "Name"
    AUTO_JOIN_TAG_VALUE       = "${local.project_tag}-consul-server"
    SERVICE_NAME_PREFIX = local.project_tag
  }))

  depends_on = [aws_nat_gateway.nat]
}