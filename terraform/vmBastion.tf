# Get CoreOS AMI
data "aws_ami" "coreosAmi" {
  most_recent = true

  owners = ["595879546273"]

  filter {
    name = "architecture"
    values = ["x86_64"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name = "name"
    values = ["CoreOS-stable-*"]
  }
}

# Bastion Instance
resource "aws_instance" "bastionInstance" {
  ami           = "${data.aws_ami.coreosAmi.id}"
  instance_type = "m4.large"
  availability_zone = "${data.aws_availability_zones.availableZones.names[0]}"
  subnet_id = "${aws_subnet.outsideSubnet.id}"
  key_name = "${aws_key_pair.deployKeyPair.key_name}"
  vpc_security_group_ids = [ 
    "${aws_security_group.outsideSecurityGroup.id}"
  ]

  tags = {
    Name = "vm-${local.recName}-bastion"
    environment = "${var.environment}"
    commonName = "${var.commonName}"
  }
}

# AWS EIP for Bastion
resource "aws_eip" "bastionEip" {
  vpc = true

  tags = {
    Name = "eip-${local.recName}-bastion"
    environment = "${var.environment}"
    commonName = "${var.commonName}"
  }
}

# AWS EIP Association for Bastion
resource "aws_eip_association" "bastionEipAssoc" {
  instance_id   = "${aws_instance.bastionInstance.id}"
  allocation_id = "${aws_eip.bastionEip.id}"
}