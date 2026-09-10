resource "azurerm_storage_account" "compliant" {
  name                     = "storage01compliant"
  resource_group_name      = azurerm_resource_group.governance.name
  location                 = azurerm_resource_group.governance.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
  }

  depends_on = [ azurerm_resource_group_policy_assignment.governance ]
}

resource "azurerm_storage_account" "non_compliant" {
  name                     = "storage02noncompliant"
  resource_group_name      = azurerm_resource_group.governance.name
  location                 = "East US"
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
  }

  depends_on = [ azurerm_resource_group_policy_assignment.governance ]
}

resource "azurerm_storage_account" "missing_tag" {

  name = "stmissingtag"

  resource_group_name = azurerm_resource_group.governance.name

  location = "Canada Central"

  account_tier = "Standard"

  account_replication_type = "LRS"


  depends_on = [
    azurerm_resource_group_policy_assignment.governance
  ]
}

resource "azurerm_storage_account" "invalid_tag" {

  name = "stinvalidtag"

  resource_group_name = azurerm_resource_group.governance.name

  location = "Canada Central"

  account_tier = "Standard"

  account_replication_type = "LRS"


  tags = {

    Environment = "production"

  }


  depends_on = [
    azurerm_resource_group_policy_assignment.governance
  ]
}