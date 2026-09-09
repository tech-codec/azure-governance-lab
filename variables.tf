variable "resource_group_name" {
  type = string
  description = "value of the resource group name"
  default = "rg-governance-demo"
}

variable "location" {
  type = string
  description = "value of location"
  default = "Canada Central"
}

variable "allowed_locations" {
  type = list(string)
  description = "List of allowed locations"
  default = ["Canada Central", "Canada East"]
}

variable "allowed_environments" {
  type = list(string)
  description = "List of allowed environments"
  default = ["dev", "staging", "prod"]
  
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