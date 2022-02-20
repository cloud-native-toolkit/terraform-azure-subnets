output "count" {
  description = "The number of subnets created"
  value       = var._count
}

output "name" {
  value = local.name_prefix
}

output "ids" {
  description = "The ids of the created subnets"
  value       = data.azurerm_subnet.subnets[*].id
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
  description = "The id of the network acl for the subnets"
  value       = length(data.azurerm_network_security_group.sg) > 0 ? data.azurerm_network_security_group.sg[0].id : ""
}

output "vpc_name" {
  description = "The name of the VPC where the subnets were provisioned"
  value       = var.vpc_name
}

output "vpc_id" {
  description = "The id of the VPC where the subnets were provisioned"
  value       = length(data.azurerm_virtual_network.vnet) > 0 ? data.azurerm_virtual_network.vnet[0].id : ""
}

output "cidr_blocks" {
  description = "The cidr block(s) assigned to the subnets"
  value       = var.ipv4_cidr_blocks
  depends_on = [data.azurerm_subnet.subnets]
}

output "enabled" {
  value = var.enabled
}
