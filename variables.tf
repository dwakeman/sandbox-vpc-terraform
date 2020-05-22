variable "schematics_workspace_name" {
    description = "the name of the schematics workspace.  Used to create a tag"
}

variable "vpc_name" {
    default = "sandbox-dallas"
}

variable "vpc_resource_group" {
    default = "vpc-sandbox"
}

variable "adm_resource_group" {
    default = "account-admin-services"
}

variable "env_resource_group" {
    default = "sandbox-env"
}

variable "region" {
    default = "us-south"
}

variable "generation" {
    default = 2
}

variable address_prefix_1 {
    default = "10.1.112.0/21"
}

variable address_prefix_2 {
    default = "10.1.120.0/21"
}

variable address_prefix_3 {
    default = "10.1.128.0/21"
}

variable adm_cidr_block_1 {
    default = "10.1.112.0/24"
}

variable adm_cidr_block_2 {
    default = "10.1.120.0/24"
}

variable adm_cidr_block_3 {
    default = "10.1.128.0/24"
}


variable app_cidr_block_1 {
    default = "10.1.113.0/24"
}

variable app_cidr_block_2 {
    default = "10.1.121.0/24"
}

variable app_cidr_block_3 {
    default = "10.1.129.0/24"
}

