terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.11.0"
    }
  }
}

# Set the subscription_id environment variable using the following command:
# export ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)
# This step is mandatory for AzureRM provider version 4.0 and above.
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "sample-wasi-http-wasmcloud-rg"
  location = "Central US"
}

resource "azurerm_kubernetes_cluster" "k8" {
  name                = "sample-wasi-http-wasmcloud-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "wasmcloud-aks"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}
