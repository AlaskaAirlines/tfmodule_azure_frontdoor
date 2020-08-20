tags = {
  ApplicationName = "EcommPlatformSharedResources"
  Contact         = "shadowquests@alaskaair.com"
  Environment     = "Dev"
  InUse           = "TRUE"
  ProductName     = "Shared Services Platform"
  Team            = "Shadow Quests"
}

resource_group_name                          = "tfmodulevalidation-test-group"
frontdoor_name                               = "tfvalfrontdoor"
frontdoor_friendly_name                      = "TF Val Front Door"
enforce_backend_pools_certificate_name_check = true
load_balancer_enabled                        = true

routing_rules = {
  rr1 = {
    name               = "defaultRoutingRule"
    frontend_endpoints = ["defaultFrontendEndpoint"]
    accepted_protocols = ["Https"]
    patterns_to_match  = ["/*"]
    enabled            = true
    configuration      = "Forwarding"
  },
  rr2 = {
    name               = "secondRoutingRule"
    frontend_endpoints = ["secondFrontendEndpoint"]
    accepted_protocols = ["Https"]
    patterns_to_match  = ["/*"]
    enabled            = true
    configuration      = "Forwarding"
  }
}

redirect_configurations = {}

forwarding_configurations = {
  fc1 = {
    routing_rule_name                     = "rr1"
    backend_pool_name                     = "defaultPool"
    cache_enabled                         = false
    cache_use_dynamic_compression         = false
    cache_query_parameter_strip_directive = "StripNone"
    custom_forwarding_path                = ""
    forwarding_protocol                   = "HttpsOnly"
  },
  fc2 = {
    routing_rule_name                     = "rr2"
    backend_pool_name                     = "secondPool"
    cache_enabled                         = false
    cache_use_dynamic_compression         = false
    cache_query_parameter_strip_directive = "StripNone"
    custom_forwarding_path                = ""
    forwarding_protocol                   = "HttpsOnly"
  }
}

backend_pool_load_balancing_configurations = {
  lb1 = {
    name                            = "defaultLoadBalancing"
    sample_size                     = 4
    successful_samples_required     = 2
    additional_latency_milliseconds = 0
  }
}

backend_pool_health_probe_configurations = {
  hp1 = {
    name                = "defaultHealthProbe"
    path                = "/"
    protocol            = "Https"
    interval_in_seconds = 120
  }
}

backend_pools = {
  bp1 = {
    name                = "defaultPool"
    load_balancing_name = "defaultLoadBalancing"
    health_probe_name   = "defaultHealthProbe"
    backends = {
      be1 = {
        enabled     = true
        address     = "platteststorage.blob.core.windows.net"
        host_header = "platteststorage.blob.core.windows.net"
        http_port   = 80
        https_port  = 443
        priority    = 1
        weight      = 50
      }
      be2 = {
        enabled     = true
        address     = "platqastorage.blob.core.windows.net"
        host_header = "platqastorage.blob.core.windows.net"
        http_port   = 80
        https_port  = 443
        priority    = 1
        weight      = 50
      }
    }
  },
  bp2 = {
    name                = "secondPool"
    load_balancing_name = "defaultLoadBalancing"
    health_probe_name   = "defaultHealthProbe"
    backends = {
      be1 = {
        enabled     = true
        address     = "platteststorage.blob.core.windows.net"
        host_header = "platteststorage.blob.core.windows.net"
        http_port   = 80
        https_port  = 443
        priority    = 1
        weight      = 50
      }
      be2 = {
        enabled     = true
        address     = "platqastorage.blob.core.windows.net"
        host_header = "platqastorage.blob.core.windows.net"
        http_port   = 80
        https_port  = 443
        priority    = 1
        weight      = 50
      }
    }
  }
}

frontend_endpoints = {
  fep1 = {
    name                              = "defaultFrontendEndpoint"
    host_name                         = "tfvalfrontdoor.azurefd.net"
    session_affinity_enabled          = false
    session_affinity_ttl_seconds      = 0
    custom_https_provisioning_enabled = false
    custom_https_configuration = {
      certificate_source = "FrontDoor"
    }
    web_application_firewall_policy_link_name = "defaultWAFPolicy"
  },
  fep2 = {
    name                              = "secondFrontendEndpoint"
    host_name                         = "tfvalfrontdoor.ecomm-test-aks.alaskaair.com"
    session_affinity_enabled          = false
    session_affinity_ttl_seconds      = 0
    custom_https_provisioning_enabled = true
    custom_https_configuration = {
      certificate_source = "FrontDoor"
    }
    web_application_firewall_policy_link_name = "secondWAFPolicy"
  }
}

frontdoor_wafs = {
  waf1 = {
    name         = "defaultWAFPolicy"
    tags         = ""
    enabled      = true
    mode         = "Prevention"
    redirect_url = "https://www.hop.com"
  },
  waf2 = {
    name         = "secondWAFPolicy"
    tags         = ""
    enabled      = true
    mode         = "Prevention"
    redirect_url = "https://www.hop.com"
  }
}

custom_rules = {
  cr1 = {
    waf      = "waf1"
    name     = "MyAccountGuidRule"
    action   = "Block"
    enabled  = true
    priority = 2
    type     = "MatchRule"
    match_condition = {
      match_variable     = "RequestHeader"
      match_values       = ["*"]
      operator           = "Contains"
      selector           = "MyAccountGuid"
      negation_condition = false
      transforms         = []
    }
    rate_limit_duration_in_minutes = 1
    rate_limit_threshold           = 10
  },
  cr2 = {
    waf      = "waf1"
    name     = "AuthorizationRule"
    action   = "Block"
    enabled  = true
    priority = 1
    type     = "MatchRule"
    match_condition = {
      match_variable     = "RequestHeader"
      match_values       = ["*"]
      operator           = "Contains"
      selector           = "Authorization"
      negation_condition = false
      transforms         = []
    }
    rate_limit_duration_in_minutes = 1
    rate_limit_threshold           = 10
  },
  cr3 = {
    waf      = "waf2"
    name     = "MyAccountGuidRule2"
    action   = "Block"
    enabled  = false
    priority = 2
    type     = "MatchRule"
    match_condition = {
      match_variable     = "RequestHeader"
      match_values       = ["*"]
      operator           = "Contains"
      selector           = "MyAccountGuid"
      negation_condition = true
      transforms         = []
    }
    rate_limit_duration_in_minutes = 1
    rate_limit_threshold           = 10
  },
  cr4 = {
    waf      = "waf2"
    name     = "AuthorizationRule2"
    action   = "Block"
    enabled  = false
    priority = 22
    type     = "MatchRule"
    match_condition = {
      match_variable     = "RequestHeader"
      match_values       = ["*"]
      operator           = "Contains"
      selector           = "Authorization"
      negation_condition = true
      transforms         = []
    }
    rate_limit_duration_in_minutes = 1
    rate_limit_threshold           = 10
  }
}

managed_rules = {
  mr1 = {
    waf     = "waf1"
    type    = "DefaultRuleSet"
    version = "1.0"
    exclusions = {
      ex1 = {
        match_variable = "QueryStringArgNames"
        operator       = "Equals"
        selector       = "not_suspicious"
      }
    }
    overrides = {
      or1 = {
        rule_group_name = "PHP"
        exclusions = {
          ex1 = {
            match_variable = "QueryStringArgNames"
            operator       = "Equals"
            selector       = "not_suspicious"
          }
        }
        rules = {
          r1 = {
            rule_id = "933100"
            action  = "Block"
            enabled = false
            exclusions = {
              ex1 = {
                match_variable = "QueryStringArgNames"
                operator       = "Equals"
                selector       = "not_suspicious"
              }
            }
          }
        }
      }
    }
  },
  mr2 = {
    waf        = "waf2"
    type       = "DefaultRuleSet"
    version    = "1.0"
    exclusions = {}
    overrides  = {}
  }
}
