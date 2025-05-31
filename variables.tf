
variable "vpc_cidr" {
  default = "10.10.0.0/16"
}

variable "public_subnet_cidr-a" {
  default = "10.10.10.0/24"
}

variable "public_subnet_cidr-c" {
  default = "10.10.11.0/24"
}

variable "private_subnet_was_cidr" {
  default = "10.10.20.0/24"
}

variable "private_subnet_db_cidr_a" {
  default = "10.10.30.0/24"
}

variable "private_subnet_db_cidr_c" {
  default = "10.10.31.0/24"
}

