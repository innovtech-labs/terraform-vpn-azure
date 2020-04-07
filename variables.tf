variable "azure-client-id" {
  description = "Client ID for Azure"
  default = "client-id"
}

variable "azure-client-secret" {
  description = "Client secret for Azure"
  default = "client-secret"
}

variable "azure-tenant" {
  description = "Tenant ID for Azure"
  default = "azure-tenant-id"
}

variable "azure-subscription" {
  description = "Subscription ID for Azure"
  default = "azure-subscription-id"
}

variable "azure-sharedkey" {
  description = "PreSjaredKey for the Site-to-Site VPN"
  default = "preshared key"
}

variable "onpremise-publicip" {
  description = "Public IP for the OnPremise gateway"
  default = "168.62.225.23"
}

variable "onpremise-address-space" {
  description = "OnPremise address space"
  default = "10.9.1.0/24"
}

variable "hubvnet-address-space" {
  description = "Address space for the hub"
  default = "10.0.0.0/16"
}

variable "hubvnet-gw-address-prefix" {
  description = "Address prefix for VNet Gateway"
  default = "10.0.255.224/27"
}

variable "hubvnet-mgmt-address-prefix" {
  description = "Address prefix for Management"
  default = "10.0.0.64/27"
}

variable "hubvnet-dmz-address-prefix" {
  description = "Address prefix for DMZ"
  default = "10.0.0.32/27"
}

variable "hubvnet-prefix" {
  description = "Prefix for hub resources"
  default = "hub"
}

variable "hubvnet-location" {
  description = "Location of the network"
  default     = "CentralUS"
}

variable "hubvnet-resource-group" {
  description = "Name of the hub resource group"
  default     = "hub-vnet-rg"
}

variable "hubvnet-vpn-address" {
  description = "Address range for Point-to-Site VPN"
  default = "10.2.0.0/24"
}

variable "hubvna-prefix" {
  description = "Prefix for the Virtual Network Appliance Hub"
  default     = "hub-vna"
}

variable "hubvna-location" {
  description = "Location for the VNA"
  default     = "CentralUS"
}

variable "hubvna-resource-group" {
  description = "Resource Group"
  default     = "hub-vna-rg"
}

variable "spoke1-location" {
  description = "Location for Spoke1"
  default = "CentralUS"
}

variable "spoke1-resource-group" {
  description = "Resource group for Spoke1"
  default = "spoke1-vnet-rg"
}

variable "spoke1-prefix" {
  description = "Resource group for Spoke1"
  default = "spoke1"
}

variable "spoke1-address-space" {
  description = "Address space group for Spoke1"
  default = "10.1.0.0/16"
}

variable "spoke1-mgmt-address-prefix" {
  description = "Address prefix for Management"
  default = "10.1.0.64/27"
}

variable "spoke1-workload-address-prefix" {
  description = "Address prefix for Workload"
  default = "10.1.1.0/24"
}

variable "spoke2-location" {
  description = "Location for Spoke2"
  default = "CentralUS"
}

variable "spoke2-resource-group" {
  description = "Resource group for Spoke2"
  default = "spoke2-vnet-rg"
}

variable "spoke2-prefix" {
  description = "Resource group for Spoke2"
  default = "spoke2"
}

variable "spoke2-address-space" {
  description = "Address space group for Spoke2"
  default = "10.2.0.0/16"
}

variable "spoke2-mgmt-address-prefix" {
  description = "Address prefix for Management"
  default = "10.2.0.64/27"
}

variable "spoke2-workload-address-prefix" {
  description = "Address prefix for Workload"
  default = "10.2.1.0/24"
}