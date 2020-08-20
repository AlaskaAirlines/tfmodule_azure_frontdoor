variable "tags" {
  type        = map(any)
  description = "Tags of the Azure Front Door WAF Policy to be created"
}

variable "resource_group_name" {
  description = "Resource Group of the Azure Front Door WAF Policy to be created"
}

variable "frontdoor_wafs" {
  type = map(object({
    name         = string
    enabled      = bool
    mode         = string
    redirect_url = string
  }))
  description = "Front Door WAF Object configuration https://www.terraform.io/docs/providers/azurerm/r/frontdoor_firewall_policy.html#argument-reference"
}

variable "custom_rules" {
  type = map(object({
    waf      = string
    name     = string
    action   = string
    enabled  = bool
    priority = number
    type     = string
    match_condition = object({
      match_variable     = string
      match_values       = list(string)
      operator           = string
      selector           = string
      negation_condition = bool
      transforms         = list(string)
    })
    rate_limit_duration_in_minutes = number
    rate_limit_threshold           = number
  }))
  description = "WAF Custom Rules"
}

variable "managed_rules" {
  type = map(object({
    waf     = string
    type    = string
    version = string
    exclusions = map(object({
      match_variable = string
      operator       = string
      selector       = string
    }))
    overrides = map(object({
      rule_group_name = string
      exclusions = map(object({
        match_variable = string
        operator       = string
        selector       = string
      }))
      rules = map(object({
        rule_id = string
        action  = string
        enabled = bool
        exclusions = map(object({
          match_variable = string
          operator       = string
          selector       = string
        }))
      }))
    }))
  }))
  description = "WAF Managed Rules"
}
