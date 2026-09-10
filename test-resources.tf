resource "azurerm_storage_account" "compliant" {
  name                     = "storage_governace_compliant"
  resource_group_name      = azurerm_resource_group.governance.name
  location                 = azurerm_resource_group.governance.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
  }

  depends_on = [ azurerm_resource_group_policy_assignment.governance ]
}