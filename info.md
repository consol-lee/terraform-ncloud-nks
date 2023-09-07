# 대략적인 설명

## modules
ㄴinit.tf - 테라폼 버전, 프로바이더 버전

ㄴmain.tf - 모듈의 구성 요소 정의 (클러스터, 노드풀, 변수 처리)

ㄴoutputs.tf - 출력값 정의

ㄴvariables.tf - 모듈에서 사용하는 변수 정의

## variables.tf

원래라면 이렇게 작성되어야 함
```
resource "ncloud_nks_node_pool" "node_pool" {
  cluster_uuid   = ncloud_nks_cluster.cluster.uuid
  node_pool_name = "sample-node-pool"
  node_count     = 1
  product_code   = data.ncloud_server_product_code.product.product_code
  subnet_no      = ncloud_subnet.subnet.id
  autoscale {
    enabled = true
    min = 1
    max = 2
  }
}
```

위 내용처럼 전달을 위해서 변수 정의
optional 한 값과 아닌 값을 구분함
```
variable "node_pools" {
  type = map(object({
    cluster_uuid   = optional(string)
    node_pool_name = string
    node_count     = number
    product_code   = string
    software_code  = optional(string)
    subnet_no_list = optional(list(string))
    k8s_version    = optional(string)
    autoscale = optional(object({
      enabled = bool
      min     = number
      max     = number
    }))
  }))
  description = "(Optional) See the description in the readme"
}
```

## main.tf

메인에는 이렇게 기재됨
nodepool 을 여러개 생성할 수 있으므로 for_each 사용
dynamic 사용 (설명 추가)

```
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
```

## example.tf

원래라면 2개의 리소스로 기재해야 하지만 node_pools 로 뭉뚱그려서 넣음

```
module "nks" {
  source = "./modules"
  ...
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
```

## 개선해야 하는 점
- 플랫폼 상관없이 진행 (default_cluster_type 수정)