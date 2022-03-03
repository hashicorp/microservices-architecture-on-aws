output "client_alb_dns" {
  value       = aws_lb.client_alb.dns_name
  description = "DNS name of the AWS ALB for Client service"
}