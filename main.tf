data "ibm_resource_group" "vpc_resource_group" {
    name = "${var.vpc_resource_group}"
}

data "ibm_resource_group" "adm_resource_group" {
    name = "${var.adm_resource_group}"
}

data "ibm_resource_group" "env_resource_group" {
    name = "${var.env_resource_group}"
}



##############################################################################
# Create VPC
##############################################################################
module "vpc" {

    source = "github.com/dwakeman/ibmcloud-terraform-modules.git//modules/vpc"
    
    vpc_name                   = var.vpc_name
    region                     = var.region
    environment                = var.environment
    schematics_workspace_name  = var.schematics_workspace_name
    vpc_resource_group         = var.vpc_resource_group
    address_prefix_cidr_blocks = ["${var.address_prefix_1}", "${var.address_prefix_2}", "${var.address_prefix_3}"]

}


##############################################################################
# Create Public Gateways
##############################################################################
module "public_gateways" {
    source = "github.com/dwakeman/ibmcloud-terraform-modules.git//modules/public_gateways?ref=v0.1.0-alpha"

    vpc_resource_group = var.vpc_resource_group
    vpc_id             = module.vpc.vpc_id
    vpc_name           = var.vpc_name
    region             = var.region

}

##############################################################################
# Create Admin Subnets
##############################################################################
module "adm_subnets" {
    source = "github.com/dwakeman/ibmcloud-terraform-modules.git//modules/subnets?ref=v0.1.0-alpha"

    vpc_id             = module.vpc.vpc_id
    resource_group     = data.ibm_resource_group.adm_resource_group.id
    region             = var.region
    subnet_name_prefix = "${var.vpc_name}-adm"
#    network_acl        = module.vpc.network_acl_id
    subnet_cidr_blocks = ["${var.adm_cidr_block_1}", "${var.adm_cidr_block_2}", "${var.adm_cidr_block_3}"]
    public_gateways    = [module.public_gateways.zone1_gateway_id, module.public_gateways.zone2_gateway_id, module.public_gateways.zone3_gateway_id]

}

##############################################################################
# Create Application Subnets
##############################################################################
module "app_subnets" {
    source = "github.com/dwakeman/ibmcloud-terraform-modules.git//modules/subnets?ref=v0.1.0-alpha"

    vpc_id             = module.vpc.vpc_id
    resource_group     = data.ibm_resource_group.env_resource_group.id
    region             = var.region
    subnet_name_prefix = "${var.vpc_name}-app"
#    network_acl        = module.vpc.network_acl_id
    subnet_cidr_blocks = ["${var.app_cidr_block_1}", "${var.app_cidr_block_2}", "${var.app_cidr_block_3}"]
    public_gateways    = [module.public_gateways.zone1_gateway_id, module.public_gateways.zone2_gateway_id, module.public_gateways.zone3_gateway_id]

}

/*
##############################################################################
# Create OpenShift Cluster
##############################################################################
resource "ibm_container_vpc_cluster" "app_cluster" {
    name              = "${var.environment}-ocp-02"
    vpc_id            = module.vpc.vpc_id
    flavor            = "bx2.4x16"
    kube_version      = "4.3_openshift"
    worker_count      = "1"
    wait_till         = "MasterNodeReady"
    disable_public_service_endpoint = true
    resource_group_id = data.ibm_resource_group.env_resource_group.id
    tags              = ["env:${var.environment}","schematics:${var.schematics_workspace_name}"]
    zones {
        subnet_id = module.app_subnets.subnet1_id
        name      = "${var.region}-1"
    }
    zones {
        subnet_id = module.app_subnets.subnet2_id
        name      = "${var.region}-2"
    }
    zones {
        subnet_id = module.app_subnets.subnet3_id
        name      = "${var.region}-3"
    }
}
*/

output vpc_id {
 value = module.vpc.vpc_id
}

output app_subnet1_id {
    value = module.app_subnets.subnet1_id
}

output app_subnet2_id {
    value = module.app_subnets.subnet2_id
}

output app_subnet3_id {
    value = module.app_subnets.subnet3_id
}
