module "subnets" {
  source = "./module"

  resource_group_name = module.resource_group.name
  region = var.region
  vpc_name = module.vpc.name
  ipv4_cidr_blocks = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  enabled = var.enabled
  acl_rules = [{
    name = "ssh-inbound"
    action = "Allow"
    direction = "Inbound"
    source = "*"
    destination = "*"
    tcp = {
      port_min = 22
      port_max = 22
      source_port_min = 22
      source_port_max = 22
    }
  }, {
    name = "ssh-outbound"
    action = "Allow"
    direction = "Outbound"
    source = "*"
    destination = "*"
    tcp = {
      port_min = 22
      port_max = 22
      source_port_min = 22
      source_port_max = 22
    }
  }, {
    name = "vpn-inbound"
    action = "Allow"
    direction = "Inbound"
    source = "*"
    destination = "*"
    udp = {
      port_min = 1194
      port_max = 1194
      source_port_min = 1194
      source_port_max = 1194
    }
  }]
}

resource null_resource print_enabled {
  provisioner "local-exec" {
    command = "echo -n '${module.subnets.enabled}' > .enabled"
  }
}
