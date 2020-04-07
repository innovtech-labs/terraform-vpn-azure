locals {
  spoke2-location       = var.spoke2-location
  spoke2-resource-group = var.spoke2-resource-group
  prefix-spoke2         = var.spoke2-prefix
}

resource "azurerm_resource_group" "spoke2-vnet-rg" {
  name     = local.spoke2-resource-group
  location = local.spoke2-location
}

resource "azurerm_virtual_network" "spoke2-vnet" {
  name                = "${local.prefix-spoke2}-vnet"
  location            = azurerm_resource_group.spoke2-vnet-rg.location
  resource_group_name = azurerm_resource_group.spoke2-vnet-rg.name
  address_space       = [var.spoke2-address-space]

  tags = {
    environment = local.prefix-spoke2
  }
}

resource "azurerm_subnet" "spoke2-mgmt" {
  name                 = "mgmt"
  resource_group_name  = azurerm_resource_group.spoke2-vnet-rg.name
  virtual_network_name = azurerm_virtual_network.spoke2-vnet.name
  address_prefix       = var.spoke2-mgmt-address-prefix
}

resource "azurerm_subnet" "spoke2-workload" {
  name                 = "workload"
  resource_group_name  = azurerm_resource_group.spoke2-vnet-rg.name
  virtual_network_name = azurerm_virtual_network.spoke2-vnet.name
  address_prefix       = var.spoke2-workload-address-prefix
}

resource "azurerm_virtual_network_peering" "spoke2-hub-peer" {
  name                      = "${local.prefix-spoke2}-hub-peer"
  resource_group_name       = azurerm_resource_group.spoke2-vnet-rg.name
  virtual_network_name      = azurerm_virtual_network.spoke2-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.hub-vnet.id

  allow_virtual_network_access = true
  allow_forwarded_traffic = true
  allow_gateway_transit   = false
  use_remote_gateways     = true
  depends_on = [azurerm_virtual_network.spoke2-vnet, azurerm_virtual_network.hub-vnet, azurerm_virtual_network_gateway.hub-vnet-gateway]
}

resource "azurerm_virtual_network_peering" "hub-spoke2-peer" {
  name                      = "hub-spoke2-peer"
  resource_group_name       = azurerm_resource_group.hub-vnet-rg.name
  virtual_network_name      = azurerm_virtual_network.hub-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.spoke2-vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic   = true
  allow_gateway_transit     = true
  use_remote_gateways       = false
  depends_on = [azurerm_virtual_network.spoke2-vnet, azurerm_virtual_network.hub-vnet, azurerm_virtual_network_gateway.hub-vnet-gateway]
}