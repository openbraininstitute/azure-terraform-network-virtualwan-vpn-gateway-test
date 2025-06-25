resource "random_pet" "vvan_name" {
  length    = 2
  separator = "-"
}

locals {
  location            = "eastus"
  resource_group_name = "rg-avm-vwan-${random_pet.vvan_name.id}"
  tags = {
    environment = "avm-vwan-testing"
    deployment  = "terraform"
  }
  virtual_hub_key           = "aue-vhub"
  virtual_hub_name          = "vhub-avm-vwan-${random_pet.vvan_name.id}"
  virtual_wan_name          = "vwan-avm-vwan-${random_pet.vvan_name.id}"
  vpn_gateways_key          = "aue-vhub-vpn-gw"
  vpn_gateways_name         = "vhub-vpn-gw-avm-vwan-${random_pet.vvan_name.id}"
  vpn_site_connections_name = "vhub-vpn-site-conn-avm-vwan-${random_pet.vvan_name.id}"
  vpn_sites_key             = "aue-vhub-vpn-site"
  vpn_sites_name            = "vhub-vpn-site-avm-vwan-${random_pet.vvan_name.id}"
}

module "vwan_with_vhub" {
  source = "./terraform-azurerm-avm-ptn-virtualwan"

  location                       = local.location
  resource_group_name            = local.resource_group_name
  virtual_wan_name               = local.virtual_wan_name
  allow_branch_to_branch_traffic = true
  create_resource_group          = true
  disable_vpn_encryption         = false
  type                           = "Standard"
  virtual_hubs = {
    (local.virtual_hub_key) = {
      name           = local.virtual_hub_name
      location       = local.location
      resource_group = local.resource_group_name
      address_prefix = "10.250.0.0/24" # doesn't clash with the address ranges in AWS
      tags           = local.tags
    }
  }
  virtual_wan_tags = local.tags
  vpn_gateways = {
    (local.vpn_gateways_key) = {
      name            = local.vpn_gateways_name
      virtual_hub_key = local.virtual_hub_key
      scale_unit      = 1
      bgp_settings = {
        asn         = 65515
        peer_weight = 0
        instance_0_bgp_peering_address = {
          custom_ips = [
            "169.254.21.1", # 169.254.21.0/30, with AWS VPN gateway using 169.254.21.1
            "169.254.21.2"
          ]
        }
        instance_1_bgp_peering_address = {
          custom_ips = [
            "169.254.21.5", # 169.254.21.4/30, with AWS VPN gateway using 169.254.21.5
            "169.254.21.6"
          ]
        }
      }
    }
  }
  vpn_site_connections = {
    "onprem1" = {
      name                = local.vpn_site_connections_name
      vpn_gateway_key     = local.vpn_gateways_key
      remote_vpn_site_key = local.vpn_sites_key

      vpn_links = [{
        name                                  = "link1"
        bandwidth_mbps                        = 10
        bgp_enabled                           = true
        local_azure_ip_address_enabled        = false
        policy_based_traffic_selector_enabled = false
        ratelimit_enabled                     = false
        route_weight                          = 1
        shared_key                            = var.aws_vpn_gateway_preshared_key1
        vpn_site_link_number                  = 0
        vpn_site_key                          = local.vpn_sites_key
        custom_bgp_addresses = [
          {
            ip_address = "169.254.21.1"
            instance   = 0
          },
          {
            ip_address = "169.254.21.5"
            instance   = 1
          }
        ]
      }]
    }
  }
  vpn_sites = {
    (local.vpn_sites_key) = {
      name            = local.vpn_sites_name
      virtual_hub_key = local.virtual_hub_key
      links = [{
        name          = "link1"
        provider_name = "Cisco"
        bgp = {
          # error in the example: azurerm_virtual_network_gateway.gw is not defined
          # assuming we need here the config of the AWS VPN gateway
          asn             = 65000          # azurerm_virtual_network_gateway.gw.bgp_settings[0].asn
          peering_address = "169.254.21.1" # azurerm_virtual_network_gateway.gw.bgp_settings[0].peering_addresses[0].default_addresses[0]
        }
        # ip_address    = data.azurerm_public_ip.gw_ip.ip_address
        fqdn          = "vpn-for-azure1.staging.openbrainplatform.org"
        speed_in_mbps = "20"
      }]
    }
  }
}
