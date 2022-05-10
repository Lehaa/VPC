
# Create VPC
resource "aws_vpc" "project" {
  cidr_block       = "10.0.0.0/24"
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  enable_classiclink = "false"

  tags = "${merge(
    "${var.common_tags}",
    tomap({
        "Name" = "VPC-Project"
        })
    )}"
}

# Create first public subnet
resource "aws_subnet" "main_public" {
  vpc_id     = "${aws_vpc.project.id}"
  cidr_block = "10.0.0.0/26"
  map_public_ip_on_launch = "true"
  availability_zone = "eu-central-1a"


  tags = "${merge(
    "${var.common_tags}",
    tomap({
        "Tier" = "Public"
        })
    )}"
}

# Create second public subnet

resource "aws_subnet" "second_public" {
  vpc_id     = "${aws_vpc.project.id}"
  cidr_block = "10.0.0.64/26"
  map_public_ip_on_launch = "true"
  availability_zone = "eu-central-1b"


  tags = "${merge(
    "${var.common_tags}",
    tomap({
        "Tier" = "Public"
        })
    )}"
}

# Create first private subnet
resource "aws_subnet" "main_private" {
  vpc_id     = "${aws_vpc.project.id}"
  cidr_block = "10.0.0.128/26"
  map_public_ip_on_launch = "false"
  availability_zone = "eu-central-1a"


  tags = "${merge(
    "${var.common_tags}",
    tomap({
        "Tier" = "Private"
        })
    )}"
}

# Create second private subnet
resource "aws_subnet" "second_private" {
  vpc_id     = "${aws_vpc.project.id}"
  cidr_block = "10.0.0.192/26"
  map_public_ip_on_launch = "false"
  availability_zone = "eu-central-1b"


  tags = "${merge(
    "${var.common_tags}",
    tomap({
        "Tier" = "Private"
        })
    )}"
}


## Outputs ##
output "vpc_id" { value = "${resource.aws_vpc.project.id}"}
output "private_subnet_a" { value = "${resource.aws_subnet.main_private.id}"}
output "private_subnet_b" { value = "${resource.aws_subnet.second_private.id}"}
output "public_subnet_a" { value = "${resource.aws_subnet.main_public.id}"}
output "public_subnet_b" { value = "${resource.aws_subnet.second_public.id}"}

