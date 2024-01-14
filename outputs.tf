# output "aws_alb_public_dns" {
#   value       = "http://${aws_lb.nginx.dns_name}"
#   description = "Public DNS for the application load balancer"
# }

output "instance_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.ubuntu1.public_ip
}