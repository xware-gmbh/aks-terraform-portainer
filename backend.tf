
#############################################################################
# BACKENDS
#############################################################################

terraform {
  backend "azurerm" {
  }

  required_providers {
    azurerm = {
      version = "=2.82.0"
    }
  }
}