variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the Public Subnet"
  default     = ["10.0.1.0/24"]
}

variable "private_subnet_cidr" {
  description = "CIDR for the Private Subnet"
  default     = ["10.0.4.0/24"]
}

variable "availability_zones" {
  description = "The availability zones"
  default     = ["eu-west-1a"]
}

variable "private_workers" {
  description = "Should be workers be placed in a private sebnet with a NAT gateway"
  default     = true
}

variable "key_name" {
  description = "Key pair name"
  default     = "MyKeyPair"
}

variable "concourse_web_instance_type" {
  description = "The EC2 instance type to run as a web instance"
  default     = "t2.micro"
}

# Workers
variable "concourse_workers_instance_type" {
  description = "The EC2 instance type to run as a worker"
  default     = "t2.micro"
}

