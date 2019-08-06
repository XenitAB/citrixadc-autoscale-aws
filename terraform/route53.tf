# Route 53 Zone
resource "aws_route53_zone" "externalDnsZone" {
  name = "${var.externalDnsZone}"
}