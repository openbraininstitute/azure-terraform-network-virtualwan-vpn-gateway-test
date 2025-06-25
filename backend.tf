terraform {
  backend "azurerm" {
    use_oidc             = true
    use_azuread_auth     = true
    storage_account_name = "openbraininsttfstate"
    container_name       = "sandbox-vwan-with-vpn-gateway-tfstate"
    key                  = "envs/sandbox-vwan-with-vpn-gateway.tfstate"
  }
}
