# AWS Key Pair for SSH
resource "aws_key_pair" "deployKeyPair" {
  key_name   = "kp-${local.recName}-deploy"
  public_key = "${var.deployPublicSshKey}"
}