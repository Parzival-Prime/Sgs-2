terraform {
  backend "azurerm" {
    resource_group_name = "sgs-2-tf-state-backend-rg"
    storage_account_name = "sgs2storg4653"
    container_name = "sgs-2-cunt-4653"
    key = "sgs-2.terraform.tfstate"
  }
}