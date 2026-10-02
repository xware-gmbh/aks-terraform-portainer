#############################################################################
# GENERAL VARIABLES
#############################################################################

variable location {
  type    = string
  default = "West Europe"
}

variable resource_group_name {
  type = string
  default = "rg-k8s-kstjj-001"
}
locals {
  full_rg_name =  join("-", [terraform.workspace, var.resource_group_name])
}

#############################################################################
# KUBERNETES VARIABLES
#############################################################################

variable "cluster_name" {
  description = "Name of the cluster, used for diff purposes"
  default     = "k8s"
}

# get supported AKS versions in your region
# $ az aks get-versions --location westeurope --output table
# $ az extension add --name aks-preview # Install the aks-preview extension
# $ az extension update --name aks-preview #Update the extension to make sure you have the latest version installed
#
variable "kubernetes_version" {
  description = "Version of Kubernetes to install"
  default     = "1.24.3"
}

# System node pool must use VM sku with more than 2 cores and 4GB memory
# https://docs.microsoft.com/en-us/azure/virtual-machines/sizes
variable "vm_size_environment" {
  type = map(string)
  default = {
    DEV = "Standard_B2s"
    TST = "Standard_B4ms"
    PRD = "Standard_B4ms"
  }
}

variable "node_count" {
  description = "Number of nodes"
  default     = 2
}

variable storage_name {
  # only letters and numbers!
  type = map(string)
  default = {
    DEV = "stk8skstjj001dev"
    TST = "stk8skstjj001tst"
    PRD = "stk8skstjj001prd"
  }
}
variable storage_share_name {
  # only letters and numbers!
  type = map(string)
  default = {
    DEV = "shstk8skstjj001dev"
    TST = "shstk8skstjj001tst"
    PRD = "shstk8skstjj001prd"
  }
}

#############################################################################
# TAGS
#
# tag_environment = terraform.workspace
# 
#############################################################################
variable "tag_owner" {
  default     = "jan.jambor@xwr.ch"
}
variable "tag_application_name" {
  default     = "k8s"
}
variable "tag_costcenter" {
  default     = "jj"
}
variable "tag_dr" {
  default     = "essential"
}