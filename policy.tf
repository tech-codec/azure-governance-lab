resource "azurerm_policy_definition" "governance" {
  name         = "governance-policy"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Governance Policy"
  description  = "This policy enforces allowed locations and environments for resources in TechCorp."
  policy_rule = jsonencode({
    if = {
      allOf = [

        # Apply only to Storage Accounts or VMs

        # Detect at least one violation
        {
          anyOf = [
            # Wrong region
            {
              field = "location"
              notIn = "[parameters('allowed_locations')]"
            },

            # Missing Environment tag
            {
              field  = "tags['Environment']"
              exists = "false"
            },

            # Invalid Environment tag
            {
              allOf = [
                {
                  field  = "tags['Environment']"
                  exists = "true"
                },
                {
                  field = "tags['Environment']"
                  notIn = "[parameters('allowed_environments')]"
                }
              ]
            }

          ]
        }

      ]
    },
    then = {
      effect = "[parameters('effect')]"
    }
  })

  parameters = jsonencode({
    allowed_locations = {
      type = "Array",
      metadata = {
        description  = "Azure regions approved by TechCorp",
        displayName = "Allowed Azure Locations"
      }
    },

    allowed_environments = {
      type = "Array",
      metadata = {
        description  = "List of allowed environments by TechCorp",
        displayName = "Allowed environments"
      }
    },

    effect = {
      type = "String",
      metadata = {
        description  = "Policy effect to be applied",
        displayName = "Policy effect"
      }
      defaultValue = var.policy_effect
    }

  })

}

resource "azurerm_resource_group_policy_assignment" "governance" {
  name                 = "techcorp-governance"
  policy_definition_id = azurerm_policy_definition.governance.id
  resource_group_id    = azurerm_resource_group.governance.id
  description          = "Applies TechCorp governance requirements to the resource group."
  display_name         = "TechCorp Governance Assignment"

  parameters = jsonencode({

    allowed_locations = {
      value = var.allowed_locations
    },

    allowed_environments = {
      value = var.allowed_environments
    },

    effect = {
      value = var.policy_effect
    }

  })
}