output "current_subscription_display_name" {
  value = data.azurerm_subscription.current.display_name
}

output "account_id" {
  value = data.azurerm_client_config.current.client_id
}