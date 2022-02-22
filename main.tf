locals {
  name_prefix = "${var.vpc_name}-subnet-${var.label}"
  acl_rules = [for i, acl_rule in var.acl_rules: merge(acl_rule, {priority=acl_rule["priority"] != null ? acl_rule["priority"] : 100 + i})]
}

resource null_resource print_name {
  count = var.enabled ? 1 : 0

  provisioner "local-exec" {
    command = "echo 'VPC name: ${var.vpc_name}'"
  }
}

data azurerm_virtual_network vnet {
  count = var.enabled ? 1 : 0
  depends_on = [null_resource.print_name]

  name                = var.vpc_name
  resource_group_name = var.resource_group_name
}

resource azurerm_subnet subnets {
  count = var.provision && var.enabled ? var._count : 0

  name                 = "${local.name_prefix}-${count.index + 1}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vpc_name
  address_prefixes     = [var.ipv4_cidr_blocks[count.index]]
  service_endpoints    = var.service_endpoints
}

data azurerm_subnet subnets {
  count = var.enabled ? var._count : 0
  depends_on = [azurerm_subnet.subnets]

  name                 = "${local.name_prefix}-${count.index + 1}"
  virtual_network_name = var.vpc_name
  resource_group_name  = var.resource_group_name
}

resource azurerm_network_security_group sg {
  count = var.provision && var.enabled ? 1 : 0

  name                = "${local.name_prefix}-sg"
  location            = var.region
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {
    for_each = [ for acl_rule in local.acl_rules: acl_rule if lookup(acl_rule, "tcp", null) != null ]

    content {
      name = security_rule.value["name"]
      priority = tonumber(security_rule.value["priority"])
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
    for_each = [ for acl_rule in local.acl_rules: acl_rule if lookup(acl_rule, "udp", null) != null ]

    content {
      name = security_rule.value["name"]
      priority = tonumber(security_rule.value["priority"])
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
    for_each = [ for acl_rule in local.acl_rules: acl_rule if lookup(acl_rule, "tcp", null) == null && lookup(acl_rule, "udp", null) == null && lookup(acl_rule, "icmp", null) == null ]

    content {
      name = security_rule.value["name"]
      priority = tonumber(security_rule.value["priority"])
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
  depends_on = [azurerm_network_security_group.sg]

  name                = "${local.name_prefix}-sg"
  resource_group_name = var.resource_group_name
}
