output "frontdoor_waf_policy" {
  value = azurerm_frontdoor_firewall_policy.default
}

output "frontdoor_waf_policy_map" {
  value = {
    for waf in azurerm_frontdoor_firewall_policy.default :
    waf.name => waf.id
  }
}
