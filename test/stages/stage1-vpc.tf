module "vpc" {
  source = "github.com/cloud-native-toolkit/terraform-azure-vpc"

  resource_group_name = module.resource_group.name
  region              = var.region
  name_prefix         = var.name_prefix
  address_prefix_count = 1
  address_prefixes    = ["10.0.0.0/16"]
  enabled             = module.resource_group.enabled
}

resource null_resource print_enabled {
  provisioner "local-exec" {
    command = "echo -n '${module.resource_group.enabled}' > .enabled"
  }
}
