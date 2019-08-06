# Add Citrix ADM IAM Role
resource "aws_iam_role" "citrixAdmRole" {
  name = "Citrix-ADM-${var.commonName}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::835822366011:root"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "${var.citrixExternalId}"
        }
      }
    }
  ]
}
EOF

  tags = {
    Name = "Citrix-ADM-${var.commonName}"
    environment = "${var.environment}"
    commonName = "${var.commonName}"
  }
}

# Citrix ADM IAM Role Policy
resource "aws_iam_role_policy" "citrixAdmIamPolicy" {
  name = "citrixADMpolicy-${var.commonName}"
  role = "${aws_iam_role.citrixAdmRole.id}"

  policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
    {
        "Action": [
            "ec2:DescribeInstances",
            "ec2:UnmonitorInstances",
            "ec2:MonitorInstances",
            "ec2:CreateKeyPair",
            "ec2:ResetInstanceAttribute",
            "ec2:ReportInstanceStatus",
            "ec2:DescribeVolumeStatus",
            "ec2:StartInstances",
            "ec2:DescribeVolumes",
            "ec2:UnassignPrivateIpAddresses",
            "ec2:DescribeKeyPairs",
            "ec2:CreateTags",
            "ec2:ResetNetworkInterfaceAttribute",
            "ec2:ModifyNetworkInterfaceAttribute",
            "ec2:DeleteNetworkInterface",
            "ec2:RunInstances",
            "ec2:StopInstances",
            "ec2:AssignPrivateIpAddresses",
            "ec2:DescribeVolumeAttribute",
            "ec2:DescribeInstanceCreditSpecifications",
            "ec2:CreateNetworkInterface",
            "ec2:DescribeImageAttribute",
            "ec2:AssociateAddress",
            "ec2:DescribeSubnets",
            "ec2:DeleteKeyPair",
            "ec2:DisassociateAddress",
            "ec2:DescribeAddresses",
            "ec2:DeleteTags",
            "ec2:RunScheduledInstances",
            "ec2:DescribeInstanceAttribute",
            "ec2:DescribeRegions",
            "ec2:DescribeDhcpOptions",
            "ec2:GetConsoleOutput",
            "ec2:DescribeNetworkInterfaces",
            "ec2:DescribeAvailabilityZones",
            "ec2:DescribeNetworkInterfaceAttribute",
            "ec2:ModifyInstanceAttribute",
            "ec2:DescribeInstanceStatus",
            "ec2:ReleaseAddress",
            "ec2:RebootInstances",
            "ec2:TerminateInstances",
            "ec2:DetachNetworkInterface",
            "ec2:DescribeIamInstanceProfileAssociations",
            "ec2:DescribeTags",
            "ec2:AllocateAddress",
            "ec2:DescribeSecurityGroups",
            "ec2:DescribeHosts",
            "ec2:DescribeImages",
            "ec2:DescribeVpcs",
            "ec2:AttachNetworkInterface",
            "ec2:AssociateIamInstanceProfile",
            "ec2:DescribeAccountAttributes",
            "ec2:DescribeInternetGateways"
        ],
        "Resource": "*",
        "Effect": "Allow",
        "Sid": "VisualEditor0"
    },
    {
        "Action": [
            "iam:GetRole",
            "iam:PassRole",
            "iam:CreateServiceLinkedRole"
        ],
        "Resource": "*",
        "Effect": "Allow",
        "Sid": "VisualEditor1"
    },
    {
        "Action": [
            "route53:CreateHostedZone",
            "route53:CreateHealthCheck",
            "route53:GetHostedZone",
            "route53:ChangeResourceRecordSets",
            "route53:ChangeTagsForResource",
            "route53:DeleteHostedZone",
            "route53:DeleteHealthCheck",
            "route53:ListHostedZonesByName",
            "route53:GetHealthCheckCount"
        ],
        "Resource": "*",
        "Effect": "Allow",
        "Sid": "VisualEditor2"
    },
    {
        "Action": [
            "iam:ListInstanceProfiles",
            "iam:ListAttachedRolePolicies",
            "iam:SimulatePrincipalPolicy",
            "iam:SimulatePrincipalPolicy"
        ],
        "Resource": "*",
        "Effect": "Allow",
        "Sid": "VisualEditor3"
    },
    {
        "Action": [
            "ec2:ReleaseAddress",
            "elasticloadbalancing:DeleteLoadBalancer",
            "ec2:DescribeAddresses",
            "elasticloadbalancing:CreateListener",
            "elasticloadbalancing:CreateLoadBalancer",
            "elasticloadbalancing:RegisterTargets",
            "elasticloadbalancing:CreateTargetGroup",
            "elasticloadbalancing:DeregisterTargets",
            "ec2:DescribeSubnets",
            "elasticloadbalancing:DeleteTargetGroup",
            "elasticloadbalancing:ModifyTargetGroupAttributes",
            "ec2:AllocateAddress"
        ],
        "Resource": "*",
        "Effect": "Allow",
        "Sid": "VisualEditor4"
    }
  ]
}
EOF
}