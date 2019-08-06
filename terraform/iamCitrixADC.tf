# Add Citrix ADC IAM Role
resource "aws_iam_role" "citrixAdcRole" {
  name = "Citrix-ADC-${var.commonName}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sts:AssumeRole"
      ],
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com"
        ]
      }
    }
  ]
}
EOF

  tags = {
    Name = "Citrix-ADC-${var.commonName}"
    environment = "${var.environment}"
    commonName = "${var.commonName}"
  }
}

# Citrix ADC IAM Role Policy
resource "aws_iam_role_policy" "citrixAdcIamPolicy" {
  name = "citrixADCpolicy-${var.commonName}"
  role = "${aws_iam_role.citrixAdcRole.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": [
        "iam:GetRole",
        "iam:SimulatePrincipalPolicy",
        "autoscaling:*",
        "sns:*",
        "sqs:*",
        "cloudwatch:*",
        "ec2:AssignPrivateIpAddresses",
        "ec2:DescribeInstances",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DetachNetworkInterface",
        "ec2:AttachNetworkInterface",
        "ec2:StartInstances",
        "ec2:StopInstances"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

# Citrix ADC Instance Profile
resource "aws_iam_instance_profile" "citrixAdcInstanceProfile" {
  name = "Citrix-ADC-${var.commonName}"
  role = "${aws_iam_role.citrixAdcRole.name}"
}