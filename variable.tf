variable "company" {
  type        = string
  description = "Company name for resource tagging"
  default     = "Cyber-Bullish"
}

variable "instance_type" {
  type        = string
  description = "Type for EC2 Instnace"
  default     = "t3.micro"
}