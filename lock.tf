resource "azurerm_management_lock" "resource-group-level" {
  name       = "resource-group-level"
  scope      = azurerm_resource_group.governance.id
  lock_level = "CanNotDelete"
  notes      = "this resource group cannot be delete"
}