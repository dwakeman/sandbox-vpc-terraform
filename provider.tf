variable "ibmcloud_api_key" {}

provider "ibm" {
    generation = var.generation
    region     = var.region
    version    = "~> 1.5"
    ibmcloud_api_key = var.ibmcloud_api_key
}
