locals {
  prefix-hub-nva         = var.hubvna-prefix
  hub-nva-location       = var.hubvna-location
  hub-nva-resource-group = var.hubvna-resource-group
}

resource "azurerm_resource_group" "hub-nva-rg" {
  name     = "${local.prefix-hub-nva}-rg"
  location = local.hub-nva-location

  tags = {
    environment = local.prefix-hub-nva
  }
}

resource "azurerm_route_table" "hub-gateway-rt" {
  name                          = "hub-gateway-rt"
  location                      = azurerm_resource_group.hub-nva-rg.location
  resource_group_name           = azurerm_resource_group.hub-nva-rg.name
  disable_bgp_route_propagation = false

  route {
    name           = "toHub"
    address_prefix = var.hubvnet-address-space
    next_hop_type  = "VnetLocal"
  }

  route {
    name                   = "toSpoke1"
    address_prefix         = var.spoke1-address-space
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.hubvnet-address-space
  }

  route {
    name                   = "toSpoke2"
    address_prefix         = var.spoke2-address-space
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.hubvnet-address-space
  }

  tags = {
    environment = local.prefix-hub-nva
  }
}

resource "azurerm_subnet_route_table_association" "hub-gateway-rt-hub-vnet-gateway-subnet" {
  subnet_id      = azurerm_subnet.hub-gateway-subnet.id
  route_table_id = azurerm_route_table.hub-gateway-rt.id
  depends_on = [azurerm_subnet.hub-gateway-subnet]
}

resource "azurerm_route_table" "spoke1-rt" {
  name                          = "spoke1-rt"
  location                      = azurerm_resource_group.hub-nva-rg.location
  resource_group_name           = azurerm_resource_group.hub-nva-rg.name
  disable_bgp_route_propagation = false

  route {
    name                   = "toSpoke2"
    address_prefix         = var.spoke2-address-space
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.0.0.36"
  }

  route {
    name           = "default"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "vnetlocal"
  }

  tags = {
    environment = local.prefix-hub-nva
  }
}

resource "azurerm_subnet_route_table_association" "spoke1-rt-spoke1-vnet-mgmt" {
  subnet_id      = azurerm_subnet.spoke1-mgmt.id
  route_table_id = azurerm_route_table.spoke1-rt.id
  depends_on = [azurerm_subnet.spoke1-mgmt]
}

resource "azurerm_subnet_route_table_association" "spoke1-rt-spoke1-vnet-workload" {
  subnet_id      = azurerm_subnet.spoke1-workload.id
  route_table_id = azurerm_route_table.spoke1-rt.id
  depends_on = [azurerm_subnet.spoke1-workload]
}

resource "azurerm_route_table" "spoke2-rt" {
  name                          = "spoke2-rt"
  location                      = azurerm_resource_group.hub-nva-rg.location
  resource_group_name           = azurerm_resource_group.hub-nva-rg.name
  disable_bgp_route_propagation = false

  route {
    name                   = "toSpoke1"
    address_prefix         = var.spoke1-address-space
    next_hop_in_ip_address = "10.0.0.36"
    next_hop_type          = "VirtualAppliance"
  }

  route {
    name           = "default"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "vnetlocal"
  }

  tags = {
    environment = local.prefix-hub-nva
  }
}

resource "azurerm_subnet_route_table_association" "spoke2-rt-spoke2-vnet-mgmt" {
  subnet_id      = azurerm_subnet.spoke2-mgmt.id
  route_table_id = azurerm_route_table.spoke2-rt.id
  depends_on = [azurerm_subnet.spoke2-mgmt]
}

resource "azurerm_subnet_route_table_association" "spoke2-rt-spoke2-vnet-workload" {
  subnet_id      = azurerm_subnet.spoke2-workload.id
  route_table_id = azurerm_route_table.spoke2-rt.id
  depends_on = [azurerm_subnet.spoke2-workload]
}