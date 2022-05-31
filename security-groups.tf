# Security Group for Client ALB
resource "aws_security_group" "client_alb" {
  name_prefix = "${local.project_tag}-ecs-client-alb"
  description = "security group for client service application load balancer"
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group_rule" "client_alb_allow_80" {
  security_group_id = aws_security_group.client_alb.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  description       = "Allow HTTP traffic."
}

resource "aws_security_group_rule" "client_alb_allow_outbound" {
  security_group_id = aws_security_group.client_alb.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  description       = "Allow any outbound traffic."
}

# Security Group for ECS Client Service.
resource "aws_security_group" "ecs_client_service" {
  name_prefix = "${local.project_tag}-ecs-client-service"
  description = "ECS Client service security group."
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group_rule" "ecs_client_service_allow_9090" {
  security_group_id        = aws_security_group.ecs_client_service.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 9090
  to_port                  = 9090
  source_security_group_id = aws_security_group.client_alb.id
  description              = "Allow incoming traffic from the client ALB into the service container port."
}

resource "aws_security_group_rule" "ecs_client_service_allow_inbound_self" {
  security_group_id = aws_security_group.ecs_client_service.id
  type              = "ingress"
  protocol          = -1
  self              = true
  from_port         = 0
  to_port           = 0
  description       = "Allow traffic from resources with this security group."
}

resource "aws_security_group_rule" "ecs_client_service_allow_outbound" {
  security_group_id = aws_security_group.ecs_client_service.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  description       = "Allow any outbound traffic."
}

resource "aws_security_group" "ecs_fruits_service" {
  name_prefix = "${local.project_tag}-ecs-fruits-service"
  description = "ECS Fruits service security group."
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group_rule" "ecs_fruits_service_allow_inbound_self" {
  security_group_id = aws_security_group.ecs_fruits_service.id
  type              = "ingress"
  protocol          = -1
  self              = true
  from_port         = 0
  to_port           = 0
  description       = "Allow traffic from resources with this security group."
}

resource "aws_security_group_rule" "ecs_fruits_service_allow_outbound" {
  security_group_id = aws_security_group.ecs_fruits_service.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  description       = "Allow any outbound traffic."
}

resource "aws_security_group" "ecs_vegetables_service" {
  name_prefix = "${local.project_tag}-ecs-vegetables-service"
  description = "ECS Vegetables service security group."
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group_rule" "ecs_vegetables_service_allow_inbound_self" {
  security_group_id = aws_security_group.ecs_vegetables_service.id
  type              = "ingress"
  protocol          = -1
  self              = true
  from_port         = 0
  to_port           = 0
  description       = "Allow traffic from resources with this security group."
}

resource "aws_security_group_rule" "ecs_vegetables_service_allow_outbound" {
  security_group_id = aws_security_group.ecs_vegetables_service.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  description       = "Allow any outbound traffic."
}

# Security Group for Database Server
resource "aws_security_group" "database" {
  name_prefix = "${local.project_tag}-database"
  description = "Database security group."
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group_rule" "database_allow_fruits_27017" {
  security_group_id        = aws_security_group.database.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 27017
  to_port                  = 27017
  source_security_group_id = aws_security_group.ecs_fruits_service.id
  description              = "Allow incoming traffic from the Fruits service onto the database port."
}

resource "aws_security_group_rule" "database_allow_vegetables_27017" {
  security_group_id        = aws_security_group.database.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 27017
  to_port                  = 27017
  source_security_group_id = aws_security_group.ecs_vegetables_service.id
  description              = "Allow incoming traffic from the Vegetables service onto the database port."
}

resource "aws_security_group_rule" "database_allow_outbound" {
  security_group_id = aws_security_group.database.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  description       = "Allow any outbound traffic."
}

resource "aws_security_group" "consul_server" {
  name_prefix = "${local.project_tag}-consul-server"
  description = "Security Group for the Consul servers"
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group_rule" "consul_server_allow_server_8300" {
  security_group_id = aws_security_group.consul_server.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 8300
  to_port           = 8300
  self              = true
  description       = "Allow RPC traffic from ConsulServer to Server. For data replication between servers."
}

resource "aws_security_group_rule" "consul_server_allow_server_8301" {
  security_group_id = aws_security_group.consul_server.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 8301
  to_port           = 8301
  self              = true
  description       = "Allow LAN gossip traffic from ConsulServer to Server. For managing cluster membership, distributed health checks of agents and event broadcasts"
}

resource "aws_security_group_rule" "consul_server_allow_server_8302" {
  security_group_id = aws_security_group.consul_server.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 8302
  to_port           = 8302
  self              = true
  description       = "Allow WAN gossip traffic from ConsulServer to Server. For cross-datacenter communication"
}

resource "aws_security_group_rule" "consul_server_allow_alb_8500" {
  security_group_id        = aws_security_group.consul_server.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 8500
  to_port                  = 8500
  source_security_group_id = aws_security_group.consul_server_alb.id
  description              = "Allow HTTP traffic from Load Balancer onto the Consul Server API."
}

resource "aws_security_group_rule" "consul_server_allow_outbound" {
  security_group_id = aws_security_group.consul_server.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow outbound traffic"
}

resource "aws_security_group_rule" "consul_server_allow_server_8501" {
  security_group_id = aws_security_group.consul_server.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 8501
  to_port           = 8501
  self              = true
  description       = "Allow HTTPS API traffic from Consul Server to Server."
}

# Access From the Consul Client to Consul Servers
resource "aws_security_group_rule" "consul_server_allow_client_8300" {
  security_group_id        = aws_security_group.consul_server.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 8300
  to_port                  = 8300
  source_security_group_id = aws_security_group.consul_client.id
  description              = "Allow RPC traffic from Consul Client to Server.  For data replication between servers."
}

resource "aws_security_group_rule" "consul_server_allow_client_8301" {
  security_group_id        = aws_security_group.consul_server.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 8301
  to_port                  = 8301
  source_security_group_id = aws_security_group.consul_client.id
  description              = "Allow LAN gossip traffic from Consul Client to Server.  For data replication between servers."
}

resource "aws_security_group_rule" "consul_server_allow_client_8500" {
  security_group_id        = aws_security_group.consul_server.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 8500
  to_port                  = 8500
  source_security_group_id = aws_security_group.consul_client.id
  description              = "Allow HTTP API traffic from Consul Client to Server."
}


resource "aws_security_group_rule" "consul_server_allow_client_8501" {
  security_group_id        = aws_security_group.consul_server.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 8501
  to_port                  = 8501
  source_security_group_id = aws_security_group.consul_client.id
  description              = "Allow HTTPS API traffic from Consul Client to Server."
}

# Consul Server ALB Security Group
resource "aws_security_group" "consul_server_alb" {
  name_prefix = "${local.project_tag}-consul-server-alb"
  description = "Security Group for the ALB fronting the consul server"
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group_rule" "consul_server_alb_allow_80" {
  security_group_id = aws_security_group.consul_server_alb.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = flatten([var.consul_server_allowed_cidr_blocks, [var.vpc_cidr]])
  description       = "Allow HTTP traffic."
}

resource "aws_security_group_rule" "consul_server_alb_allow_outbound" {
  security_group_id = aws_security_group.consul_server_alb.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  description       = "Allow any outbound traffic."
}

resource "aws_security_group" "acl_controller" {
  name_prefix = "${local.project_tag}-acl-controller-"
  description = "Consul ACL Controller service security group."
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group_rule" "acl_controller_allow_inbound_self" {
  security_group_id = aws_security_group.acl_controller.id
  type              = "ingress"
  protocol          = -1
  self              = true
  from_port         = 0
  to_port           = 0
  description       = "Allow traffic from resources with this security group."
}

resource "aws_security_group_rule" "acl_controller_allow_outbound" {
  security_group_id = aws_security_group.acl_controller.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  description       = "Allow any outbound traffic."
}

# A Generalized group for all consul clients
resource "aws_security_group" "consul_client" {
  name_prefix = "${local.project_tag}-consul-client-"
  description = "General security group for consul clients."
  vpc_id      = aws_vpc.main.id
}

# Required for gossip traffic between each client
resource "aws_security_group_rule" "consul_client_allow_inbound_self_8301" {
  security_group_id = aws_security_group.consul_client.id
  type              = "ingress"
  protocol          = "tcp"
  self              = true
  from_port         = 8301
  to_port           = 8301
  description       = "Allow LAN Serf traffic from resources with this security group."
}

# Required to allow the proxies to contact each other
resource "aws_security_group_rule" "consul_client_allow_inbound_self_20000" {
  security_group_id = aws_security_group.consul_client.id
  type              = "ingress"
  protocol          = "tcp"
  self              = true
  from_port         = 20000
  to_port           = 20000
  description       = "Allow Proxy traffic from resources with this security group."
}

resource "aws_security_group_rule" "consul_client_allow_outbound" {
  security_group_id = aws_security_group.consul_client.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  description       = "Allow any outbound traffic."
}
