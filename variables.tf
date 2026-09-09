variable "resource_group_name" {
  type = string
  description = "value of the resource group name"
  default = "rg-governance"
}

variable "location" {
  type = string
  description = "value of location"
  default = "canadacentral"
}

variable "allowed_locations" {
  type = list(string)
  description = "List of allowed locations"
  default = ["canadacentral", "eastus", "westus"]
}

variable "allowed_environments" {
  type = list(string)
  description = "List of allowed environments"
  default = ["dev", "test", "prod"]
  
}

variable "policy_effect" {
  type = string
  description = "Policy effect to be applied"
  default = "Deny"
  validation {
    condition = contains(["Deny", "Audit", "Disabled"], var.policy_effect)
    error_message = "Policy effect must be one of: Deny, Audit, Disabled"
  }
}