output "client_alb_dns" {
  value       = aws_lb.client_alb.dns_name
  description = "DNS name of the AWS ALB for Client service"
}

output "consul_bootstrap_token" {
  description = "The Consul Bootstrap token.  Do not share!"
  sensitive   = true
  value       = random_uuid.consul_bootstrap_token.result
}

output "consul_server_endpoint" {
  description = "The ALB endpoint for the Consul Servers."
  value       = aws_lb.consul_server_alb.dns_name
}

output "project_tag" {
  description = "the tag used on all deployed resources and also as the service prefix"
  value = local.project_tag
}