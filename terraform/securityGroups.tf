# Create security group for management
resource "aws_security_group" "mgmtSecurityGroup" {
  name        = "secg-${local.recName}-management"
  description = "Security Group for management"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [ 
      "${var.mgmtSubnet}",
      "${aws_instance.bastionInstance.private_ip}/32"
    ]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [ 
      "${var.mgmtSubnet}"
    ]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [ 
      "${var.mgmtSubnet}"
    ]
  }

  ingress {
    from_port   = 3008
    to_port     = 3011
    protocol    = "tcp"
    cidr_blocks = [ 
      "${var.mgmtSubnet}"
    ]
  }

  ingress {
    from_port   = 4001
    to_port     = 4001
    protocol    = "tcp"
    cidr_blocks = [ 
      "${var.mgmtSubnet}"
    ]
  }

  ingress {
    from_port   = 67
    to_port     = 67
    protocol    = "udp"
    cidr_blocks = [ 
      "${var.mgmtSubnet}"
    ]
  }

  ingress {
    from_port   = 123
    to_port     = 123
    protocol    = "udp"
    cidr_blocks = [ 
      "${var.mgmtSubnet}"
    ]
  }

  ingress {
    from_port   = 500
    to_port     = 500
    protocol    = "udp"
    cidr_blocks = [ 
      "${var.mgmtSubnet}"
    ]
  }

  ingress {
    from_port   = 3003
    to_port     = 3003
    protocol    = "udp"
    cidr_blocks = [ 
      "${var.mgmtSubnet}"
    ]
  }

  ingress {
    from_port   = 4500
    to_port     = 4500
    protocol    = "udp"
    cidr_blocks = [ 
      "${var.mgmtSubnet}"
    ]
  }

  ingress {
    from_port   = 7000
    to_port     = 7000
    protocol    = "udp"
    cidr_blocks = [ 
      "${var.mgmtSubnet}"
    ]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "secg-${local.recName}-management"
    environment = "${var.environment}"
    commonName = "${var.commonName}"
  }
}

# Create security group for outside
resource "aws_security_group" "outsideSecurityGroup" {
  name        = "secg-${local.recName}-outside"
  description = "Security Group for outside"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [ 
      "${var.outsideSubnet}",
      "${var.externalManagementIp}"
    ]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [ 
      "${var.outsideSubnet}"
    ]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [ 
      "${var.outsideSubnet}"
    ]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "secg-${local.recName}-outside"
    environment = "${var.environment}"
    commonName = "${var.commonName}"
  }
}

# Create security group for inside
resource "aws_security_group" "insideSecurityGroup" {
  name        = "secg-${local.recName}-inside"
  description = "Security Group for inside"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [ 
      "${var.insideSubnet}"
    ]
  }

  egress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks = [ 
      "${var.insideSubnet}"
    ]
  }

  tags = {
    Name = "secg-${local.recName}-inside"
    environment = "${var.environment}"
    commonName = "${var.commonName}"
  }
}