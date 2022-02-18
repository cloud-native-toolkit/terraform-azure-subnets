locals {
  name_prefix = "${var.vpc_name}-subnet-${var.label}"
  count = length(var.ipv4_cidr_blocks)
}

data azurerm_virtual_network vnet {
  count = var.enabled ? 1 : 0

  name                = var.vpc_name
  resource_group_name = var.resource_group_name
}

resource azurerm_subnet subnets {
  count = var.provision && var.enabled ? 1 : 0

  name                 = local.name_prefix
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vpc_name
  address_prefixes     = var.ipv4_cidr_blocks
}

data azurerm_subnet subnets {
  count = var.enabled ? 1 : 0

  name                 = local.name_prefix
  virtual_network_name = var.vpc_name
  resource_group_name  = var.resource_group_name
}

resource azurerm_network_security_group sg {
  count = var.provision && var.enabled ? 1 : 0

  name                = "${local.name_prefix}-sg"
  location            = var.region
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {
    for_each = [ for acl_rule in var.acl_rules: acl_rule if lookup(acl_rule, "tcp", null) != null ]

    content {
      name = security_rule.value["name"]
      priority = lookup(security_rule.value, "priority", 100)
      direction = security_rule.value["direction"]
      access = security_rule.value["action"]
      protocol = "Tcp"
      source_address_prefix = security_rule.value["source"]
      destination_address_prefix = security_rule.value["destination"]
      source_port_range          = "${lookup(security_rule.value["tcp"], "source_port_min", 0)} - ${lookup(security_rule.value["tcp"], "source_port_max", 65535)}"
      destination_port_range     = "${lookup(security_rule.value["tcp"], "port_min", 0)} - ${lookup(security_rule.value["tcp"], "port_max", 65535)}"
    }
  }

  dynamic "security_rule" {
    for_each = [ for acl_rule in var.acl_rules: acl_rule if lookup(acl_rule, "udp", null) != null ]

    content {
      name = security_rule.value["name"]
      priority = lookup(security_rule.value, "priority", 100)
      direction = security_rule.value["direction"]
      access = security_rule.value["action"]
      protocol = "Udp"
      source_address_prefix = security_rule.value["source"]
      destination_address_prefix = security_rule.value["destination"]
      source_port_range          = "${lookup(security_rule.value["udp"], "source_port_min", 0)} - ${lookup(security_rule.value["udp"], "source_port_max", 65535)}"
      destination_port_range     = "${lookup(security_rule.value["udp"], "port_min", 0)} - ${lookup(security_rule.value["udp"], "port_max", 65535)}"
    }
  }

  dynamic "security_rule" {
    for_each = [ for acl_rule in var.acl_rules: acl_rule if lookup(acl_rule, "tcp", null) == null && lookup(acl_rule, "udp", null) == null && lookup(acl_rule, "icmp", null) == null ]

    content {
      name = security_rule.value["name"]
      priority = lookup(security_rule.value, "priority", 100)
      direction = security_rule.value["direction"]
      access = security_rule.value["action"]
      protocol = "*"
      source_address_prefix = security_rule.value["source"]
      destination_address_prefix = security_rule.value["destination"]
      source_port_range          = "*"
      destination_port_range     = "*"
    }
  }
}

data azurerm_network_security_group sg {
  count = var.enabled ? 1 : 0

  name                = "${local.name_prefix}-sg"
  resource_group_name = var.resource_group_name
}
