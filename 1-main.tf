provider "azurerm" {
  client_id = var.azure-client-id
  client_secret = var.azure-client-secret
  tenant_id = var.azure-tenant
  subscription_id = var.azure-subscription
  features {}
}