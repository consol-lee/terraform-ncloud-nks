terraform {
  required_providers {
    ncloud = {
      source = "NaverCloudPlatform/ncloud"
    }
  }
  required_version = ">= 0.15"
}

provider "ncloud" {
  access_key  = var.ncloud_access_key
  secret_key  = var.ncloud_secret_key
  region      = var.ncloud_region
  site        = var.ncloud_site
  support_vpc = var.ncloud_support_vpc
}
