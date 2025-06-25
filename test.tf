# Create a dummy resource group to test the terraform setup

resource "azurerm_resource_group" "test_rg" {
  name     = "terraform_test"
  location = "eastus"
}
