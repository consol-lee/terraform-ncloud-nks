output "cluster_name" {
  value = ncloud_nks_cluster.cluster.name
}

output "cluster_uuid" {
  value = ncloud_nks_cluster.cluster.uuid
}

locals {
  node_pool_info = {
    for node_pool_key, node_pool in ncloud_nks_node_pool.node_pool :
    node_pool_key => {
      name = node_pool.node_pool_name
    }
  }
}

output "node_pool_info" {
  value = local.node_pool_info
}
