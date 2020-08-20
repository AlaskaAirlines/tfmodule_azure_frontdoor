#Create 1 to x Azure Front Door WAF Policies
module "frontdoor_waf" {
  source              = "./modules/frontdoor_waf"
  resource_group_name = var.resource_group_name
  frontdoor_wafs      = var.frontdoor_wafs
  tags                = var.tags
  custom_rules        = var.custom_rules
  managed_rules       = var.managed_rules
}

#Create Azure Front Door Resource
resource "azurerm_frontdoor" "default" {
  depends_on                                   = [module.frontdoor_waf]
  name                                         = var.frontdoor_name
  friendly_name                                = var.frontdoor_friendly_name
  resource_group_name                          = var.resource_group_name
  enforce_backend_pools_certificate_name_check = var.enforce_backend_pools_certificate_name_check
  load_balancer_enabled                        = var.load_balancer_enabled
  tags                                         = var.tags

  dynamic "routing_rule" {
    for_each = var.routing_rules
    content {
      name               = routing_rule.value.name
      accepted_protocols = routing_rule.value.accepted_protocols
      patterns_to_match  = routing_rule.value.patterns_to_match
      frontend_endpoints = routing_rule.value.frontend_endpoints

      dynamic "forwarding_configuration" {
        for_each = [
          for k, v in var.forwarding_configurations : { key = k, config = v } if(v.routing_rule_name == routing_rule.key) && (routing_rule.value.configuration == "Forwarding")
        ]
        content {
          backend_pool_name                     = forwarding_configuration.value.config.backend_pool_name
          cache_enabled                         = forwarding_configuration.value.config.cache_enabled
          cache_use_dynamic_compression         = forwarding_configuration.value.config.cache_use_dynamic_compression #default: false
          cache_query_parameter_strip_directive = forwarding_configuration.value.config.cache_query_parameter_strip_directive
          custom_forwarding_path                = forwarding_configuration.value.config.custom_forwarding_path
          forwarding_protocol                   = forwarding_configuration.value.config.forwarding_protocol
        }
      }

      dynamic "redirect_configuration" {
        for_each = [
          for k, v in var.redirect_configurations : { key = k, config = v } if(v.routing_rule_name == routing_rule.key) && (routing_rule.value.configuration == "Redirecting")
        ]
        content {
          custom_host         = redirect_configuration.value.config.custom_host
          redirect_protocol   = redirect_configuration.value.config.redirect_protocol
          redirect_type       = redirect_configuration.value.config.redirect_type
          custom_fragment     = redirect_configuration.value.config.custom_fragment
          custom_path         = redirect_configuration.value.config.custom_path
          custom_query_string = redirect_configuration.value.config.custom_query_string
        }
      }
    }
  }

  dynamic "backend_pool_load_balancing" {
    for_each = var.backend_pool_load_balancing_configurations
    content {
      name                            = backend_pool_load_balancing.value.name
      sample_size                     = backend_pool_load_balancing.value.sample_size
      successful_samples_required     = backend_pool_load_balancing.value.successful_samples_required
      additional_latency_milliseconds = backend_pool_load_balancing.value.additional_latency_milliseconds
    }
  }

  dynamic "backend_pool_health_probe" {
    for_each = var.backend_pool_health_probe_configurations
    content {
      name                = backend_pool_health_probe.value.name
      path                = backend_pool_health_probe.value.path
      protocol            = backend_pool_health_probe.value.protocol
      interval_in_seconds = backend_pool_health_probe.value.interval_in_seconds
    }
  }

  dynamic "frontend_endpoint" {
    for_each = var.frontend_endpoints
    content {
      name                              = frontend_endpoint.value.name
      host_name                         = frontend_endpoint.value.host_name
      session_affinity_enabled          = frontend_endpoint.value.session_affinity_enabled
      session_affinity_ttl_seconds      = frontend_endpoint.value.session_affinity_ttl_seconds
      custom_https_provisioning_enabled = frontend_endpoint.value.custom_https_provisioning_enabled

      dynamic "custom_https_configuration" {
        for_each = frontend_endpoint.value.custom_https_provisioning_enabled == true ? [frontend_endpoint.value.custom_https_configuration] : []
        content {
          certificate_source = custom_https_configuration.value.certificate_source
        }
      }
      web_application_firewall_policy_link_id = frontend_endpoint.value.web_application_firewall_policy_link_name != "" ? module.frontdoor_waf.frontdoor_waf_policy_map[frontend_endpoint.value.web_application_firewall_policy_link_name] : ""
    }
  }

  dynamic "backend_pool" {
    for_each = var.backend_pools
    content {
      name                = backend_pool.value.name
      load_balancing_name = backend_pool.value.load_balancing_name
      health_probe_name   = backend_pool.value.health_probe_name

      dynamic "backend" {
        for_each = backend_pool.value.backends
        content {
          enabled     = backend.value.enabled
          address     = backend.value.address
          host_header = backend.value.host_header
          http_port   = backend.value.http_port
          https_port  = backend.value.https_port
          priority    = backend.value.priority
          weight      = backend.value.weight
        }
      }
    }
  }
}
