# Get Citrix ADM Agent AMI
data "aws_ami" "citrixAdmAgentAmi" {
  most_recent      = true
  owners           = ["aws-marketplace"]

  filter {
    name   = "name"
    values = ["*dc05bddd-a003-45d1-b90a-7a10a3ea528d*"]
  }
}

# Citrix ADM Agent Instance
resource "aws_instance" "citrixAdmAgentInstance" {
  ami           = "${data.aws_ami.citrixAdmAgentAmi.id}"
  instance_type = "m4.xlarge"
  availability_zone = "${data.aws_availability_zones.availableZones.names[0]}"
  subnet_id = "${aws_subnet.mgmtSubnet.id}"
  key_name = "${aws_key_pair.deployKeyPair.key_name}"
  vpc_security_group_ids = [ 
    "${aws_security_group.mgmtSecurityGroup.id}"
  ]

  tags = {
    Name = "vm-${local.recName}-admagent"
    environment = "${var.environment}"
    commonName = "${var.commonName}"
  }
}