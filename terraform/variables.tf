variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
  default     = "t2.micro"
}

variable "ami" {
  description = "AMI ID (si no quieres usar data lookup)"
  type        = string
  default     = ""
}
