variable "name" {
  type        = string
  description = "See the description in the readme"
}

variable "max_nodes" {
  type        = number
  description = "Maximum number of nodes. 10 or 50"
  default     = 10
}

variable "cluster_type" {
  type        = string
  description = "Maximum number of nodes. SVR.VNKS.STAND.C002.M008.NET.SSD.B050.G002 or SVR.VNKS.STAND.C004.M016.NET.SSD.B050.G002"
  default     = null
}

variable "login_key_name" {
  type        = string
  description = "See the description in the readme"
}

variable "zone" {
  type        = string
  description = "See the description in the readme"
}

variable "vpc_no" {
  type        = number
  description = "See the description in the readme"
}

variable "subnet_no_list" {
  type        = list(string)
  description = "See the description in the readme"
}

variable "public_network" {
  type        = bool
  description = "(Optional)See the description in the readme"
  default     = false
}

variable "lb_private_subnet_no" {
  type        = number
  description = "See the description in the readme"
}

variable "lb_public_subnet_no" {
  type        = number
  description = "(Optional)See the description in the readme"
  default     = null
}

variable "kube_network_plugin" {
  type        = string
  description = "(Optional)See the description in the readme"
  default     = "cilium"
}

variable "log" {
  description = "(Optional)See the description in the readme"
  type = object({
    audit = bool
  })
  default = {
    audit = false
  }
}
variable "k8s_version" {
  type        = string
  description = "(Optional)See the description in the readme"
  default     = null
}

variable "oidc" {
  type = object({
    issuer_url      = string
    client_id       = string
    username_prefix = optional(string)
    username_claim  = optional(string)
    groups_prefix   = optional(string)
    groups_claim    = optional(string)
    required_claim  = optional(string)
  })

  default     = null
  description = "(Optional) See the description in the readme"
}

variable "ip_acl_default_action" {
  type        = string
  default     = "allow"
  description = "(Optional)See the description in the readme"
}

variable "ip_acl" {
  type = list(object({
    action  = string
    address = string
    comment = optional(string)
  }))

  default     = []
  description = "(Optional) See the description in the readme"
}

###### node_pool

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
