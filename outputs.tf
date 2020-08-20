output "frontdoor" {
  value = azurerm_frontdoor.default
}

output "id" {
  value = azurerm_frontdoor.default.id
}

output "name" {
  value = azurerm_frontdoor.default.name
}

output "cname" {
  value = azurerm_frontdoor.default.cname
}

output "frontend_endpoint_map" {
  value = {
    for fep in azurerm_frontdoor.default.frontend_endpoint :
    fep.name => fep.host_name
  }
}

output "frontdoor_waf_policy" {
  value = module.frontdoor_waf.frontdoor_waf_policy
}

output "frontdoor_waf_policy_map" {
  value = module.frontdoor_waf.frontdoor_waf_policy_map
}
