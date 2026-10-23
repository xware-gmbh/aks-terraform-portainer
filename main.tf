#############################################################################
# PROVIDERS
#############################################################################

provider "azurerm" {
    features {
        key_vault {
            recover_soft_deleted_key_vaults = false #defaults to true
        }
    }
}

#############################################################################
# RESOURCES DEFAULT
#############################################################################

resource "azurerm_resource_group" "default" {
    name     = local.full_rg_name
    location = var.location
}

#############################################################################
# RESOURCES KUBERNETES AKS
#############################################################################

resource "azurerm_kubernetes_cluster" "default" {
  name                = var.cluster_name
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  dns_prefix          = var.cluster_name
  kubernetes_version  = var.kubernetes_version
  
  # automatic_channel_upgrade         = "rapid" # only available in preview right now
  
  default_node_pool {
    name                  = "default"
    node_count            = var.node_count
    orchestrator_version  = var.kubernetes_version
    vm_size               = var.vm_size_environment[terraform.workspace]
  }

  role_based_access_control {
    enabled     = true
  }

  identity {
    type = "SystemAssigned"
  }

  addon_profile {
  
    aci_connector_linux {
      enabled = false
    }

    azure_policy {
      enabled = false
    }

    http_application_routing {
      enabled = false
    }

    kube_dashboard {
      enabled = false
    }

    oms_agent {
      enabled = false
    }

  }

  tags = {
    Environment = terraform.workspace
    Owner = var.tag_owner
    ApplicationName = var.tag_application_name
    CostCenter = var.tag_costcenter
    DR = var.tag_dr
  }

}

#############################################################################
# Storage & Storage Share - admin parts
#############################################################################
resource "azurerm_storage_account" "default" {
    name                      = var.storage_name[terraform.workspace]
    resource_group_name       = azurerm_resource_group.default.name
    location                  = azurerm_resource_group.default.location
    account_kind              = "Storage" # defaults "StorageV2"
    account_tier              = "Standard"
    account_replication_type  = "LRS"
    enable_https_traffic_only = "true"

    tags = {
      Environment = terraform.workspace
      Owner = var.tag_owner
      ApplicationName = var.tag_application_name
      CostCenter = var.tag_costcenter
      DR = var.tag_dr
    }
}

resource "azurerm_storage_share" "defaultk8s" {
    name                 = var.storage_share_name[terraform.workspace]
    storage_account_name = azurerm_storage_account.default.name
    quota                = 50
}

#############################################################################
# TODO: update ip address in DNS
# https://github.com/terraform-providers/terraform-provider-azurerm/issues/10233
#############################################################################
