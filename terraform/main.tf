# Configure backend
terraform {
  backend "s3" {}
}

# Configure the AWS Provider
provider "aws" {
  region = "${var.region}"
  version = "~> 2.22"
}

# Add data reference to availability zones
data "aws_availability_zones" "availableZones" {
  state = "available"
}

# Declare local values
locals {
  recName = "${var.regionShort}-${var.environmentShort}-${var.commonName}"
}