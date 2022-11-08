terraform {
  required_version = ">= 0.15.0, < 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.27.0"
    }
  }

  experiments = [module_variable_optional_attrs]
}
