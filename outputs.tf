output "count" {
  description = "The number of subnets created"
  value       = local.subnet_qty
  depends_on = [data.azurerm_subnet.subnets]
}

output "name" {
  value = local.name_prefix
  depends_on = [data.azurerm_subnet.subnets]
}

output "ids" {
  description = "The ids of the created subnets"
  value       = data.azurerm_subnet.subnets[*].id
}

output "id" {
  description = "The ids of the created subnets"
  value       = data.azurerm_subnet.subnets[0].id
}

output "names" {
  description = "The ids of the created subnets"
  value       = data.azurerm_subnet.subnets[*].name
}

output "subnets" {
  description = "The subnets that were created"
  value       = [ for subnet in data.azurerm_subnet.subnets: {id = subnet.id, zone = var.region, label = var.label} ]
}

output "acl_id" {
  description = "The id of the network security group for the subnets"
  value       = length(data.azurerm_network_security_group.nsg) > 0 ? data.azurerm_network_security_group.nsg[0].id : ""
}

output "vnet_name" {
  description = "The name of the VNet where the subnets were provisioned"
  value       = var.vnet_name
  depends_on = [data.azurerm_subnet.subnets]
}

output "vnet_id" {
  description = "The id of the VNet where the subnets were provisioned"
  value       = length(data.azurerm_virtual_network.vnet) > 0 ? data.azurerm_virtual_network.vnet.id : ""
}

output "cidr_blocks" {
  description = "The cidr block(s) assigned to the subnets"
  value       = var.ipv4_cidr_blocks
  depends_on = [data.azurerm_subnet.subnets]
}

