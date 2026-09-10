resource "azurerm_role_assignment" "devops_contributor" {
  scope = azurerm_resource_group.governance.id

  role_definition_name = "Contributor"

  principal_id = data.azurerm_client_config.current.object_id
  
}