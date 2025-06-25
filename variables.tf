variable "subscription_id" {
  description = "The subscription id to use"
  type        = string
}

variable "aws_vpn_gateway_preshared_key1" {
  description = "The preshared key for the AWS VPN gateway tunnel 1"
  type        = string
  sensitive   = true
}

variable "aws_vpn_gateway_preshared_key2" {
  description = "The preshared key for the AWS VPN gateway tunnel 2"
  type        = string
  sensitive   = true
}
