# Configure the HuaweiCloud Provider with AK/SK
# This will work with a single defined/default network, otherwise you need to specify network
# to fix errors about multiple networks found.
provider "huaweicloud" {
  region     = var.region
  access_key = var.ak
  secret_key = var.sk
  auth_url   = "https://iam.${var.region}.myhuaweicloud.com/v3"
}

# Get a list of availability zones
data "huaweicloud_availability_zones" "zones" {}

# Create a VPC, Network and Subnet
resource "huaweicloud_vpc_v1" "vpc_v1" {
  name = "vpc-hdc-tf-test"
  cidr = "192.168.0.0/16"
}

resource "huaweicloud_vpc_subnet_v1" "subnet_v1" {
  name       = "subnet-hdc-tf-test"
  cidr       = "192.168.0.0/24"
  gateway_ip = "192.168.0.1"
  vpc_id     = huaweicloud_vpc_v1.vpc_v1.id
}

# Create Security Group and rule ssh
resource "huaweicloud_networking_secgroup_v2" "secgroup_1" {
  name        = "secgroup_tf_1"
  description = "My security group"
}

resource "huaweicloud_networking_secgroup_rule_v2" "secgroup_rule_1" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = huaweicloud_networking_secgroup_v2.secgroup_1.id
}

# Create ECS
resource "huaweicloud_compute_instance_v2" "basic" {
  name = "basic_hdc_tf"
  # image_name        = "Windows Server 2012 R2 Datacenter 64bit English"
  # image_id    = "94fab7d2-8728-48c5-9ffd-241b9232a2b6"
  image_id    = "87d974ac-8f5c-462c-b6d7-086a62f68ba0"
  flavor_name = "s3.medium.4"
  # key_pair          = "KeyPair-TF"
  security_groups   = [huaweicloud_networking_secgroup_v2.secgroup_1.name]
  availability_zone = data.huaweicloud_availability_zones.zones.names[0]


  network {
    uuid = huaweicloud_vpc_subnet_v1.subnet_v1.id
  }
  depends_on = [
    huaweicloud_vpc_subnet_v1.subnet_v1
  ]
}

# Variables
variable "ak" {
  type = string
}

variable "sk" {
  type = string
}

variable "region" {
  type = string
}