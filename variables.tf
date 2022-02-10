variable "tags" {
  type        = map(any)
  description = "Tags of the Azure Front Door WAF Policy to be created"
}

variable "resource_group_name" {
  description = "Resource Group of the Azure Front Door to be created"
}

variable "frontdoor_name" {
  type        = string
  description = "The name of your front door"
}

variable "load_balancer_enabled" {
  type        = string
  description = "The flag to determine whether or not load balancing is enabled on your front door"
}

variable "frontdoor_friendly_name" {
  type        = string
  description = "The friendly name of your front door"
}

variable "enforce_backend_pools_certificate_name_check" {
  type        = bool
  description = "The flag to determine if you want to validate backend pool certificate names"
}

variable "routing_rules" {
  type = map(object({
    name               = string
    frontend_endpoints = list(string)
    accepted_protocols = list(string)
    patterns_to_match  = list(string)
    enabled            = bool
    configuration      = string
  }))
  description = "The routing rules for your frontizzle"
}

variable "forwarding_configurations" {
  type = map(object({
    routing_rule_name                     = string
    backend_pool_name                     = string
    cache_enabled                         = bool
    cache_use_dynamic_compression         = bool
    cache_query_parameter_strip_directive = string
    custom_forwarding_path                = string
    forwarding_protocol                   = string
  }))

  description = "The forwarding configuration for your routing_rules"
}

variable "redirect_configurations" {
  type = map(object({
    routing_rule_name   = string
    custom_host         = string
    redirect_protocol   = string
    redirect_type       = string
    custom_fragment     = string
    custom_path         = string
    custom_query_string = string
  }))

  description = "The redirect configuration for your routing_rules"
}

variable "backend_pool_load_balancing_configurations" {
  type = map(object({
    name                            = string
    sample_size                     = number
    successful_samples_required     = number
    additional_latency_milliseconds = number
  }))
  description = "The load balancing configurations to pair with your backend pools"
}

variable "backend_pool_health_probe_configurations" {
  type = map(object({
    name                = string
    path                = string
    protocol            = string
    interval_in_seconds = number
  }))
  description = "The health probe configurations to pair with your backend pools"
}

variable "backend_pools" {
  type = map(object({
    name                = string
    load_balancing_name = string
    health_probe_name   = string
    backends = map(object({
      enabled     = bool
      address     = string
      host_header = string
      http_port   = number
      https_port  = number
      priority    = number
      weight      = number
    }))
  }))
  description = "The backend pools for your front door"
}

variable "frontend_endpoints" {
  type = map(object({
    name                              = string
    host_name                         = string
    session_affinity_enabled          = bool
    session_affinity_ttl_seconds      = number
    custom_https_provisioning_enabled = bool
    custom_https_configuration = object({
      certificate_source = string
    })
    web_application_firewall_policy_link_name = string
  }))
  description = "The front door endpoint resources for your front door"
}

variable "frontdoor_wafs" {
  type = map(object({
    name         = string
    enabled      = bool
    mode         = string
    redirect_url = string
  }))
  description = "Front Door WAF Object configuration https://www.terraform.io/docs/providers/azurerm/r/frontdoor_firewall_policy.html#argument-reference"
  default     = {}
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
  default     = {}
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
  default     = {}
}
