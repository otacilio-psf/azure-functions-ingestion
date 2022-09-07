# TF_VAR_ environment variables
variable "SUBSCRIPTION_ID" {}
variable "TENANT_ID" {}
variable "SP_TERRAFORM_ID" {}
variable "SP_TERRAFORM_SECRET" {}
variable "SP_DATA_LAKE_CONTRIBUTOR_ID" {}
variable "SP_DATA_LAKE_CONTRIBUTOR_SECRET" {}

# tfvars file
variable "project_initials" {}
variable "location" {
  default = "West Europe"
}

data "azurerm_client_config" "current" {}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }

  subscription_id = var.SUBSCRIPTION_ID
  tenant_id       = var.TENANT_ID
  client_id       = var.SP_TERRAFORM_ID
  client_secret   = var.SP_TERRAFORM_SECRET
}

resource "azurerm_resource_group" "project" {
  name     = "rg-${var.project_initials}-01"
  location = var.location
}