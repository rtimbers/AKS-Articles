terraform {
  backend "azurerm" {
    resource_group_name  = "AksTerraform-RG"
    storage_account_name = "terraformbuild081021"
    container_name       = "tfstate"
    key                  = "demo.terraform.tfstate"
    subscription_id      = "33853dbd-283a-4e73-b0a4-910968ce34bc"
    tenant_id            = "70e8a976-af29-4379-97e0-e6132dc015d4"
  }
}