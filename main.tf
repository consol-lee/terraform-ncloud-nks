module "nks" {
  source = "./modules"
  name   = "nks-module-cluster"
  #cluster_type         = "SVR.VNKS.STAND.C004.M016.NET.SSD.B050.G002"
  max_nodes            = "50"
  k8s_version          = null
  login_key_name       = "hansol-real"
  lb_private_subnet_no = "86986"
  subnet_no_list       = ["84393", "84394"]
  vpc_no               = "10610"
  zone                 = "KR-2"
  node_pools = {
    "node_1" = {
      node_count     = 2
      node_pool_name = "pub-node-2"
      product_code   = "SVR.VSVR.STAND.C002.M008.NET.SSD.B050.G002"
      subnet_no_list = ["84393", "84394"]
    },
    "node_2" = {
      node_count     = 1
      node_pool_name = "pub-node-1"
      product_code   = "SVR.VSVR.STAND.C002.M008.NET.SSD.B050.G002"
      subnet_no_list = ["84393"]
    }
  }
}
