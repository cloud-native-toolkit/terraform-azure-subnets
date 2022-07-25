resource "random_string" "cluster_id" {
    length = 5
    special = false
    upper = false
}

module "resource_group" {
  source = "github.com/cloud-native-toolkit/terraform-azure-resource-group"

  resource_group_name = "${var.resource_group_name}-${random_string.cluster_id.result}"
  region              = var.region
}
