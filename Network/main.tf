
# Create Internet Gateway
resource "aws_internet_gateway" "igw-project" {
  vpc_id = "${var.vpc_id}"

  tags = "${merge(
    "${var.common_tags}",
    tomap({
        "Name" = "IGW-Project"
        })
    )}"
}

# Create public route_table
resource "aws_route_table" "main_public" {
  vpc_id = "${var.vpc_id}"

  tags = "${merge(
    "${var.common_tags}",
    tomap({
        "Name" = "PublicRoute-Project"
        })
    )}"
}

resource "aws_route" "route_public_a" {
  route_table_id = "${aws_route_table.main_public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.igw-project.id}"
}

# Route associations public
resource "aws_route_table_association" "main_public_a" {
  subnet_id      = "${var.public_subnet_a}"
  route_table_id = "${aws_route_table.main_public.id}"
}

resource "aws_route_table_association" "second_public_b" {
  subnet_id      = "${var.public_subnet_b}"
  route_table_id = "${aws_route_table.main_public.id}"
}


# Create Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  vpc      = true
  tags = "${merge(
    "${var.common_tags}",
    tomap({
        "Name" = "EIP-Project"
        })
    )}"
}

# Create NAT Gateway
resource "aws_nat_gateway" "nat_project" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${var.public_subnet_a}"

  tags = "${merge(
    "${var.common_tags}",
    tomap({
        "Name" = "NAT-Project"
        })
    )}"

  depends_on = [resource.aws_internet_gateway.igw-project]
}


# Create private NAT route_table
resource "aws_route_table" "main_private" {
  vpc_id = "${var.vpc_id}"

  tags = "${merge(
    "${var.common_tags}",
    tomap({
        "Name" = "PrivateRoute-Project"
        })
    )}"
}

# Create private route to NAT
resource "aws_route" "route_private" {
  route_table_id = "${aws_route_table.main_private.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.nat_project.id}"
}

# Route associations private
resource "aws_route_table_association" "route_private_a" {
  subnet_id      = "${var.private_subnet_a}"
  route_table_id = "${aws_route_table.main_private.id}"
}

resource "aws_route_table_association" "route_private_b" {
  subnet_id      = "${var.private_subnet_b}"
  route_table_id = "${aws_route_table.main_private.id}"
}

# Create Security Group for Public EC2
resource "aws_security_group" "publicSG" {
  name = "PublicSG" # can use expressions here
  vpc_id      = "${var.vpc_id}"

  dynamic "ingress" {
    for_each = "${var.public_ports}"
    content {
      from_port = ingress.key
      to_port   = ingress.key
      cidr_blocks = ingress.value
      protocol  = "tcp"
    }
  }
  egress = [
    {
      description      = "for all outgoing traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      prefix_list_ids = []
      cidr_blocks = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      security_groups = []
      self = false
    }
  ]
  tags = "${merge(
    "${var.common_tags}",
    tomap({
        "Name" = "PublicSG-Project",
        "Tier" = "Public"
        })
    )}"
}

# Create Security Group for Private EC2
resource "aws_security_group" "privateSG" {
  name = "PrivateSG" # can use expressions here
  vpc_id      = "${var.vpc_id}"

  dynamic "ingress" {
    for_each = "${var.private_ports}"
    content {
      from_port = ingress.key
      to_port   = ingress.key
      security_groups = ["${aws_security_group.publicSG.id}"]
      protocol  = "tcp"
    }
  }
  egress = [
    {
      description      = "for all outgoing traffics"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      prefix_list_ids = []
      cidr_blocks = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      security_groups = []
      self = false
    }
  ]
  tags = "${merge(
    "${var.common_tags}",
    tomap({
        "Name" = "PrivateSG-Project",
        "Tier" = "Private"
        })
    )}"
}