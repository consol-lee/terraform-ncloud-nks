data "ncloud_nks_versions" "versions" {}

data "ncloud_nks_cluster" "cluster" {
  uuid = ncloud_nks_cluster.cluster.id
}

locals {
  default_version      = data.ncloud_nks_versions.versions.versions[0].value
  default_cluster_type = var.max_nodes != null ? (var.max_nodes == 10 ? "SVR.VNKS.STAND.C002.M008.NET.SSD.B050.G002" : (var.max_nodes == 50 ? "SVR.VNKS.STAND.C004.M016.NET.SSD.B050.G002" : null)) : null
}

resource "ncloud_nks_cluster" "cluster" {
  name                 = var.name
  cluster_type         = var.cluster_type != null ? var.cluster_type : local.default_cluster_type
  k8s_version          = var.k8s_version != null ? var.k8s_version : local.default_version
  login_key_name       = var.login_key_name
  lb_private_subnet_no = var.lb_private_subnet_no
  lb_public_subnet_no  = var.lb_public_subnet_no
  public_network       = var.public_network
  kube_network_plugin  = var.kube_network_plugin
  subnet_no_list       = var.subnet_no_list
  vpc_no               = var.vpc_no
  zone                 = var.zone
  log {
    audit = var.log.audit
  }
  dynamic "oidc" {
    for_each = var.oidc != null ? [var.oidc] : []
    content {
      issuer_url      = oidc.value.issuer_url
      client_id       = oidc.value.client_id
      username_prefix = oidc.value.username_prefix
      username_claim  = oidc.value.username_claim
      groups_prefix   = oidc.value.groups_prefix
      groups_claim    = oidc.value.groups_claim
      required_claim  = oidc.value.required_claim
    }
  }
  ip_acl_default_action = var.ip_acl_default_action
  dynamic "ip_acl" {
    for_each = var.ip_acl
    content {
      action  = ip_acl.value.action
      address = ip_acl.value.address
      comment = ip_acl.value.comment
    }
  }
}

resource "ncloud_nks_node_pool" "node_pool" {
  for_each = var.node_pools

  cluster_uuid   = data.ncloud_nks_cluster.cluster.uuid
  node_pool_name = each.value.node_pool_name
  node_count     = each.value.node_count
  product_code   = each.value.product_code
  software_code  = each.value.software_code
  subnet_no_list = each.value.subnet_no_list
  k8s_version    = each.value.k8s_version

  dynamic "autoscale" {
    for_each = each.value.autoscale != null ? [each.value.autoscale] : []
    content {
      enabled = autoscale.value.enabled
      min     = autoscale.value.min
      max     = autoscale.value.max
    }
  }
}
