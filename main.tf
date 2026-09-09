resource "azurerm_resource_group" "governance" {
  name     = var.resource_group_name
  location = var.location
  tags = {
    "Environment" = var.allowed_environments[0]
    "ManagedBy"   = "Terraform"
    "Project"     = "GovernanceLab"
  }
}