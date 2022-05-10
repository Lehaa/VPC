variable "common_tags"{
     type = map(string) 

}
variable "vpc_id" {
    description = "VPC ID"
}

variable "private_subnet_a" {
    description = "First Private subnet ID"
}

variable "private_subnet_b" {
    description = "Second Private subnet ID"
}

variable "public_subnet_a" {
    description = "First Public subnet ID"
}

variable "public_subnet_b" {
    description = "Second Public subnet ID"
}

variable "public_ports" { 
    type = map(list(string))
}

variable "private_ports" { 
    type = map(list(string))
}