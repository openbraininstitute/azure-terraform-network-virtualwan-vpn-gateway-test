

# Azure Verified Module 'virtualwan'

The directory terraform-azurerm-avm-ptn-virtualwan contains the [Azure
Verified Module for VirtualWAN
networking](https://registry.terraform.io/modules/Azure/avm-ptn-virtualwan/azurerm/latest) which was cloned from https://github.com/Azure/terraform-azurerm-avm-ptn-virtualwan
. It's git version
[6eb87fce412a2c5c8487e0390b520f6afb58649c](https://github.com/Azure/terraform-azurerm-avm-ptn-virtualwan/commit/6eb87fce412a2c5c8487e0390b520f6afb58649c)
of the 16th of June 2025 (latest on 24th of June 2025).

To have a self contained example, it's simply a copy of the terraform files within this repository.
The unaltered version: [commit 6b019c912785e5f3918aad000f2c57a2fb0bb76a](https://github.com/openbraininstitute/azure-terraform-network-virtualwan-vpn-gateway-test/commit/6b019c912785e5f3918aad000f2c57a2fb0bb76a)


I applied changes from PR https://github.com/Azure/terraform-azurerm-avm-ptn-virtualwan/pull/170 :
* The diff of the PR: https://github.com/Azure/terraform-azurerm-avm-ptn-virtualwan/compare/main...rafabu:terraform-azurerm-avm-ptn-virtualwan:feature/s2sconnection-nonsensitive-foreach
* The commit within this repo: [commit 2a83f223d783bb987ad48cccb7874b324efca282](https://github.com/openbraininstitute/azure-terraform-network-virtualwan-vpn-gateway-test/commit/2a83f223d783bb987ad48cccb7874b324efca282)

# Main code

The Azure Verified Module for VirtualWAN contains an example with a site-to-site
VPN gateway at https://registry.terraform.io/modules/Azure/avm-ptn-virtualwan/azurerm/latest/examples/s2svpn
That example refers to some resources which are not part of the example, so it doesn't seem to work out of the box.
* The original example added to this repo: [commit a575d4974adf544f25e1a88798d8bb5be4a14c13](https://github.com/openbraininstitute/azure-terraform-network-virtualwan-vpn-gateway-test/commit/a575d4974adf544f25e1a88798d8bb5be4a14c13)
* The modifications done to the example, currently deployed: [commit
01f375c05be8bdf1b7143d23886c6ab979a0cdfc](https://github.com/openbraininstitute/azure-terraform-network-virtualwan-vpn-gateway-test/commit/01f375c05be8bdf1b7143d23886c6ab979a0cdfc).
The changes are minimal: for example it only defines a single connection, as was done in the original example.

# AWS side

The VPN gateway at the AWS side is deployed from the [aws-terraform-deployment-common repo](https://github.com/openbraininstitute/aws-terraform-deployment-common/).
The gateway is configured in the ['vpn_to_azure' module in the
main.tf](https://github.com/openbraininstitute/aws-terraform-deployment-common/blob/534fd3df3d337a9612e71a17213ee06fb1c02082/main.tf#L261).
