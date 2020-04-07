locals {
  prefix-hub         = var.hubvnet-prefix
  hub-location       = var.hubvnet-location
  hub-resource-group = var.hubvnet-resource-group
  shared-key         = var.azure-sharedkey
}

resource "azurerm_resource_group" "hub-vnet-rg" {
  name     = local.hub-resource-group
  location = local.hub-location
}

resource "azurerm_virtual_network" "hub-vnet" {
  name                = "${local.prefix-hub}-vnet"
  location            = azurerm_resource_group.hub-vnet-rg.location
  resource_group_name = azurerm_resource_group.hub-vnet-rg.name
  address_space       = [var.hubvnet-address-space]

  tags = {
    environment = "hub-spoke"
  }
}

resource "azurerm_subnet" "hub-gateway-subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.hub-vnet-rg.name
  virtual_network_name = azurerm_virtual_network.hub-vnet.name
  address_prefix       = var.hubvnet-gw-address-prefix
}

resource "azurerm_subnet" "hub-mgmt" {
  name                 = "mgmt"
  resource_group_name  = azurerm_resource_group.hub-vnet-rg.name
  virtual_network_name = azurerm_virtual_network.hub-vnet.name
  address_prefix       = var.hubvnet-mgmt-address-prefix
}

resource "azurerm_subnet" "hub-dmz" {
  name                 = "dmz"
  resource_group_name  = azurerm_resource_group.hub-vnet-rg.name
  virtual_network_name = azurerm_virtual_network.hub-vnet.name
  address_prefix       = var.hubvnet-dmz-address-prefix
}

# Virtual Network Gateway
resource "azurerm_public_ip" "hub-vpn-gateway1-pip" {
  name                = "hub-vpn-gateway1-pip"
  location            = azurerm_resource_group.hub-vnet-rg.location
  resource_group_name = azurerm_resource_group.hub-vnet-rg.name

  allocation_method = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "hub-vnet-gateway" {
  name                = "hub-vpn-gateway1"
  location            = azurerm_resource_group.hub-vnet-rg.location
  resource_group_name = azurerm_resource_group.hub-vnet-rg.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.hub-vpn-gateway1-pip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.hub-gateway-subnet.id
  }

  vpn_client_configuration {
    address_space = [var.hubvnet-vpn-address]

    root_certificate {
      name = "DigiCert-Federated-ID-Root-CA"
      public_cert_data = <<EOF
MIIDuzCCAqOgAwIBAgIQCHTZWCM+IlfFIRXIvyKSrjANBgkqhkiG9w0BAQsFADBn
MQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3
d3cuZGlnaWNlcnQuY29tMSYwJAYDVQQDEx1EaWdpQ2VydCBGZWRlcmF0ZWQgSUQg
Um9vdCBDQTAeFw0xMzAxMTUxMjAwMDBaFw0zMzAxMTUxMjAwMDBaMGcxCzAJBgNV
BAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdp
Y2VydC5jb20xJjAkBgNVBAMTHURpZ2lDZXJ0IEZlZGVyYXRlZCBJRCBSb290IENB
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvAEB4pcCqnNNOWE6Ur5j
QPUH+1y1F9KdHTRSza6k5iDlXq1kGS1qAkuKtw9JsiNRrjltmFnzMZRBbX8Tlfl8
zAhBmb6dDduDGED01kBsTkgywYPxXVTKec0WxYEEF0oMn4wSYNl0lt2eJAKHXjNf
GTwiibdP8CUR2ghSM2sUTI8Nt1Omfc4SMHhGhYD64uJMbX98THQ/4LMGuYegou+d
GTiahfHtjn7AboSEknwAMJHCh5RlYZZ6B1O4QbKJ+34Q0eKgnI3X6Vc9u0zf6DH8
Dk+4zQDYRRTqTnVO3VT8jzqDlCRuNtq6YvryOWN74/dq8LQhUnXHvFyrsdMaE1X2
DwIDAQABo2MwYTAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBhjAdBgNV
HQ4EFgQUGRdkFnbGt1EWjKwbUne+5OaZvRYwHwYDVR0jBBgwFoAUGRdkFnbGt1EW
jKwbUne+5OaZvRYwDQYJKoZIhvcNAQELBQADggEBAHcqsHkrjpESqfuVTRiptJfP
9JbdtWqRTmOf6uJi2c8YVqI6XlKXsD8C1dUUaaHKLUJzvKiazibVuBwMIT84AyqR
QELn3e0BtgEymEygMU569b01ZPxoFSnNXc7qDZBDef8WfqAV/sxkTi8L9BkmFYfL
uGLOhRJOFprPdoDIUBB+tmCl3oDcBy3vnUeOEioz8zAkprcb3GHwHAK+vHmmfgcn
WsfMLH4JCLa/tRYL+Rw/N3ybCkDp00s0WUZ+AoDywSl0Q/ZEnNY0MsFiw6LyIdbq
M/s/1JRtO3bDSzD9TazRVzn2oBqzSa8VgIo5C1nOnoAKJTlsClJKvIhnRlaLQqk=
EOF
    }

    revoked_certificate {
      name = "Verizon-Global-Root-CA"
      thumbprint = "912198EEF23DCAC40939312FEE97DD560BAE49B1"
    }
  }

  depends_on = [azurerm_public_ip.hub-vpn-gateway1-pip]
}

resource "azurerm_local_network_gateway" "onpremise" {
  name = "onpremise"
  location = azurerm_resource_group.hub-vnet-rg.location
  resource_group_name = azurerm_resource_group.hub-vnet-rg.name
  gateway_address = var.onpremise-publicip
  address_space = [var.onpremise-address-space]
}

resource "azurerm_virtual_network_gateway_connection" "onpremise" {
  name = "onpremise"
  location = azurerm_resource_group.hub-vnet-rg.location
  resource_group_name = azurerm_resource_group.hub-vnet-rg.name

  type = "IPSec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.hub-vnet-gateway.id
  local_network_gateway_id = azurerm_local_network_gateway.onpremise.id

  shared_key = local.shared-key
}