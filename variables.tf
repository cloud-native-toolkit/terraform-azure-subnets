variable "resource_group_name" {
  type        = string
  description = "The name of the Azure resource group where the VPC has been provisioned."
}

variable "region" {
  type        = string
  description = "The IBM Cloud region where the cluster will be/has been installed."
}

variable "vpc_name" {
  type        = string
  description = "The name of the vpc instance"
}
variable "subnet_name" {
  type        = string
  description = "The name of the subnet instance"
  default = ""
}

variable "label" {
  type        = string
  description = "Label for the subnets created"
  default     = "default"
}

variable "_count" {
  type        = number
  description = "The number of subnets that should be provisioned"
  default     = 0
}

variable "ipv4_cidr_blocks" {
  type        = list(string)
  description = "List of ipv4 cidr blocks for the subnets that will be created (e.g. ['10.10.10.0/24']). If you are providing cidr blocks then a value must be provided for each of the subnets. If you don't provide cidr blocks for each of the subnets then values will be generated using the {ipv4_address_count} value."
  default     = []
}

variable "provision" {
  type        = bool
  description = "Flag indicating that the NSG should be provisioned."
  default     = true
}

variable "acl_rules" {
  type = list(object({
    name=string,
    action=string,
    direction=string,
    source=string,
    destination=string,
    priority=optional(number),
    tcp=optional(object({
      destination_port_range=string,
      source_port_range=string
    })),
    udp=optional(object({
      destination_port_range=string,
      source_port_range=string
    })),
    icmp=optional(object({
      type=number,
      code=optional(number)
    })),
  }))
  description = "List of rules to set on the subnet access control list"
  default = []
}


variable "service_endpoints" {
  type        = list(string)
  description = "The list of service endpoints for the subnet"
  default     = [
    "Microsoft.ContainerRegistry"
  ]
}

variable "disable_private_link_endpoint_network_policies" {
  type        = bool
  description = "Flag to disable private link endpoint network policies in the subnet."
  default     = false
}
