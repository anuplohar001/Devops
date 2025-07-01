variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
}

variable "access_key" {
  description = "AWS Access Key"
  type        = string
  sensitive   = true
}

variable "secret_key" {
  description = "AWS Secret Access Key"
  type        = string
  sensitive   = true
}
