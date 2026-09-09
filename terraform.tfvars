resource_group_name = "rg-governance-demo"

location = "Canada Central"

allowed_locations = [
  "Canada Central",
  "Canada East"
]

allowed_environments = [
  "dev",
  "staging",
  "prod"
]

policy_effect = "Audit"