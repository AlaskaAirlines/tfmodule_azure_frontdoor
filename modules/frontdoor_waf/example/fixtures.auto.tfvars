tags = {
  ApplicationName = "EcommPlatformSharedResources"
  Contact         = "shadowquests@alaskaair.com"
  Environment     = "Dev"
  InUse           = "TRUE"
  ProductName     = "Shared Services Platform"
  Team            = "Shadow Quests"
}

resource_group_name = "tfmodulevalidation-test-group"

frontdoor_wafs = {
  waf1 = {
    name         = "submoduledefaultWAF"
    tags         = ""
    enabled      = true
    mode         = "Prevention"
    redirect_url = "https://www.hop.com"
  },
  waf2 = {
    name         = "submodulesecondWAF"
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
