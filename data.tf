# Note: filter out wavelength zones if they're enabled in the account being deployed to.
# If these aren't filtered out, they'll throw an error when trying to assign an IPv6 CIDR block.
data "aws_availability_zones" "available" {
  state = "available"
  filter {
    name   = "group-name"
    values = [var.region]
  }
}