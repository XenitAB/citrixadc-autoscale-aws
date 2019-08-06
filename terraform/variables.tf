variable "citrixExternalId" {
  description = "Citrix External ID from ADM"
  default = ""
}

variable "region" {
  description = "The AWS region to create things in."
  default = "eu-central-1"
}

variable "regionShort" {
  description = "The AWS region short name."
  default = "euc1"
}

variable "environment" {
  description = "The environment to use for the deploy"
  default = "development"
}

variable "environmentShort" {
  description = "The environment (short name) to use for the deploy"
  default = "dev"
}

variable "commonName" {
  description = "The common name for the deployment"
  default = "adcautoscale"
}

variable "vpcCidrBlock" {
  description = "The CIDR block for the VPC"
  default = "10.0.0.0/16"
}

variable "mgmtSubnet" {
  description = "The subnet for management"
  default = "10.0.255.0/24"
}

variable "outsideSubnet" {
  description = "The subnet for outside"
  default = "10.0.254.0/24"
}

variable "insideSubnet" {
  description = "The subnet for inside"
  default = "10.0.253.0/24"
}

variable "deployPublicSshKey" {
  description = "Public SSH Key for deployments"
}

variable "externalManagementIp" {
  description = "External Management IP to access instances"
}

variable "externalDnsZone" {
  description = "The external DNS Zone to be used"
}