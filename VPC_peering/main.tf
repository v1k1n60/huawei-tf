provider "huaweicloud" {
    region = var.region
    access_key = var.ak
    secret_key = var.sk
}

variable "region" {
  type = string
}

variable "ak" {
  type = string
}

variable "sk" {
  type = string
}



resource "huaweicloud_vpc_v1" "vpc_v1" {
  name = "vpc-01"
  cidr = "192.168.0.0/16"
}

resource "huaweicloud_vpc_subnet_v1" "subnet_v1" {
  name       = "subnet-01"
  cidr       = "192.168.0.0/24"
  gateway_ip = "192.168.0.1"
  vpc_id     = huaweicloud_vpc_v1.vpc_v1.id
}

resource "huaweicloud_vpc_v1" "vpc_v2" {
  name = "vpc-02"
  cidr = "172.16.0.0/16"
}

resource "huaweicloud_vpc_subnet_v1" "subnet_v2" {
  name = "subnet-02"
  cidr = "172.16.0.0/24"
  gateway_ip = "172.16.0.1"
  vpc_id = huaweicloud_vpc_v1.vpc_v2.id
}

resource "huaweicloud_vpc_peering_connection" "peering" {
  name = "vpc_peering-vpc01-vpc02"
  vpc_id = huaweicloud_vpc_v1.vpc_v1.id
  peer_vpc_id = huaweicloud_vpc_v1.vpc_v2.id
}

resource "huaweicloud_vpc_route" "vpc_route01" {
  vpc_id      = huaweicloud_vpc_v1.vpc_v1.id
  destination = "172.16.0.0/24"
  type        = "peering"
  nexthop     = huaweicloud_vpc_peering_connection.peering.id
}

resource "huaweicloud_vpc_route" "vpc_route02" {
  vpc_id      = huaweicloud_vpc_v1.vpc_v2.id
  destination = "192.168.0.0/24"
  type        = "peering"
  nexthop     = huaweicloud_vpc_peering_connection.peering.id
}

data "huaweicloud_availability_zones" "zones" {}

data "huaweicloud_networking_secgroups" "secgroups" {
  name = "default"
}

data "huaweicloud_networking_secgroup" "secgroup" {
  name = "default"
}

resource "huaweicloud_compute_instance_v2" "basic01" {
  name              = "ECS_01"
  image_name        = "Ubuntu 18.04 server 64bit"
  flavor_name       = "s6.medium.2"
  security_group_ids = [data.huaweicloud_networking_secgroup.secgroup.id]
  availability_zone = data.huaweicloud_availability_zones.zones.names[0]


  network {
    uuid = huaweicloud_vpc_subnet_v1.subnet_v1.id
  }
  depends_on = [
    huaweicloud_vpc_subnet_v1.subnet_v1
  ]
}

resource "huaweicloud_compute_instance_v2" "basic02" {
  name              = "ECS_02"
  image_name        = "Ubuntu 18.04 server 64bit"
  flavor_name       = "s6.medium.2"
  security_group_ids = [data.huaweicloud_networking_secgroup.secgroup.id]
  availability_zone = data.huaweicloud_availability_zones.zones.names[1]


  network {
    uuid = huaweicloud_vpc_subnet_v1.subnet_v2.id
  }
  depends_on = [
    huaweicloud_vpc_subnet_v1.subnet_v2
  ]
}
