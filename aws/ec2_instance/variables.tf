variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-1"
}
variable "cidr_block" {
  default = "172.31.0.0/16"
}

variable "instance_type" {
  description = "Type of EC2 instance to provision"
  type        = string
  default     = "t2.micro"
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "free-tier-linux-instance"
}
variable "subnet_name" {
  default = "default-subnet"
}
