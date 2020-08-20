output "frontdoor" {
  value = module.tfmodule_azure_frontdoor.frontdoor
}

output "id" {
  value = module.tfmodule_azure_frontdoor.id
}

output "name" {
  value = module.tfmodule_azure_frontdoor.name
}

output "cname" {
  value = module.tfmodule_azure_frontdoor.cname
}

output "frontend_endpoint_map" {
  value = module.tfmodule_azure_frontdoor.frontend_endpoint_map
}

output "frontdoor_waf_policy" {
  value = module.tfmodule_azure_frontdoor.frontdoor_waf_policy
}

output "frontdoor_waf_policy_map" {
  value = module.tfmodule_azure_frontdoor.frontdoor_waf_policy_map
}
