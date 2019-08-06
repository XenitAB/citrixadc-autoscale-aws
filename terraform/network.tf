# Create a VPC
resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpcCidrBlock}"

  tags = {
    Name = "vpc-${local.recName}"
    environment = "${var.environment}"
    commonName = "${var.commonName}"
  }
}

# Create management subnet
resource "aws_subnet" "mgmtSubnet" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.mgmtSubnet}"
  availability_zone = "${data.aws_availability_zones.availableZones.names[0]}"

  tags = {
    Name = "subnet-${local.recName}-management"
    environment = "${var.environment}"
    commonName = "${var.commonName}"
  }
}
# Create outside subnet
resource "aws_subnet" "outsideSubnet" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.outsideSubnet}"
  availability_zone = "${data.aws_availability_zones.availableZones.names[0]}"

  tags = {
    Name = "subnet-${local.recName}-outside"
    environment = "${var.environment}"
    commonName = "${var.commonName}"
  }
}

# Create inside subnet
resource "aws_subnet" "insideSubnet" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.insideSubnet}"
  availability_zone = "${data.aws_availability_zones.availableZones.names[0]}"

  tags = {
    Name = "subnet-${local.recName}-inside"
    environment = "${var.environment}"
    commonName = "${var.commonName}"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name = "igw-${local.recName}"
    environment = "${var.environment}"
    commonName = "${var.commonName}"
  }
}

# Create Elastic IP resource for NAT Gateway
resource "aws_eip" "natEip" {
  vpc = true

  tags = {
    Name = "eip-${local.recName}-nat"
    environment = "${var.environment}"
    commonName = "${var.commonName}"
  }
}

# Create NAT Gateway
resource "aws_nat_gateway" "ngw" {
  allocation_id = "${aws_eip.natEip.id}"
  subnet_id     = "${aws_subnet.outsideSubnet.id}"

  tags = {
    Name = "ngw-${local.recName}"
    environment = "${var.environment}"
    commonName = "${var.commonName}"
  }
}

# Create Management Route Table
resource "aws_route_table" "mgmtRouteTable" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.ngw.id}"
  }

  tags = {
    Name = "rt-${local.recName}-management"
    environment = "${var.environment}"
    commonName = "${var.commonName}"
  }
}

# Create Management Route Table Association
resource "aws_route_table_association" "mgmtRouteTableAssociation" {
  subnet_id      = "${aws_subnet.mgmtSubnet.id}"
  route_table_id = "${aws_route_table.mgmtRouteTable.id}"
}

# Create Outside Route Table
resource "aws_route_table" "outsideRouteTable" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags = {
    Name = "rt-${local.recName}-outside"
    environment = "${var.environment}"
    commonName = "${var.commonName}"
  }
}

# Create Management Route Table Association
resource "aws_route_table_association" "outsideRouteTableAssociation" {
  subnet_id      = "${aws_subnet.outsideSubnet.id}"
  route_table_id = "${aws_route_table.outsideRouteTable.id}"
}