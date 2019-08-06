# Get LAMP AMI
data "aws_ami" "lampAmi" {
  most_recent = true

  owners = ["679593333241"]

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
    values = ["bitnami-lampstack-*"]
  }
}

# LAMP Launch Template
resource "aws_launch_template" "lampLaunchTemplate" {
  name_prefix   = "vm-${local.recName}-lamp"
  image_id    = "${data.aws_ami.lampAmi.id}"
  instance_type = "t3.micro"

  network_interfaces {
    subnet_id = "${aws_subnet.insideSubnet.id}"
    security_groups = [ 
      "${aws_security_group.insideSecurityGroup.id}"
    ]
  }

  key_name = "${aws_key_pair.deployKeyPair.key_name}"


}

# LAMP Autoscaling Group
resource "aws_autoscaling_group" "lampAutoscalingGroup" {
  availability_zones = [
    "${data.aws_availability_zones.availableZones.names[0]}"
  ]

  desired_capacity  = 1
  max_size          = 1
  min_size          = 1

  launch_template {
    id    = "${aws_launch_template.lampLaunchTemplate.id}"
    version = "$Latest"
  }
}