terraform {
  required_version = ">= 0.15.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
  }

  experiments = [module_variable_optional_attrs]
}
