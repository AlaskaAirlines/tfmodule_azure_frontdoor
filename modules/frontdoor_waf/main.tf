resource "azurerm_frontdoor_firewall_policy" "default" {
  for_each            = var.frontdoor_wafs
  name                = each.value.name
  resource_group_name = var.resource_group_name
  tags                = var.tags
  enabled             = each.value.enabled
  mode                = each.value.mode
  redirect_url        = each.value.redirect_url

  dynamic "custom_rule" {
    for_each = [
      for k, v in var.custom_rules : { key = k, rule = v } if v.waf == each.key
    ]

    content {
      name     = custom_rule.value.rule.name
      action   = custom_rule.value.rule.action
      enabled  = custom_rule.value.rule.enabled
      priority = custom_rule.value.rule.priority
      type     = custom_rule.value.rule.type

      dynamic "match_condition" {
        for_each = [custom_rule.value.rule.match_condition]
        content {
          match_variable     = match_condition.value.match_variable
          match_values       = match_condition.value.match_values
          operator           = match_condition.value.operator
          selector           = match_condition.value.selector
          negation_condition = match_condition.value.negation_condition
          transforms         = match_condition.value.transforms
        }
      }

      rate_limit_duration_in_minutes = custom_rule.value.rule.rate_limit_duration_in_minutes
      rate_limit_threshold           = custom_rule.value.rule.rate_limit_threshold
    }
  }

  dynamic "managed_rule" {
    for_each = [
      for k, v in var.managed_rules : { key = k, rule = v } if v.waf == each.key
    ]
    content {
      type    = managed_rule.value.rule.type
      version = managed_rule.value.rule.version

      dynamic "exclusion" {
        for_each = managed_rule.value.rule.exclusions
        content {
          match_variable = exclusion.value.match_variable
          operator       = exclusion.value.operator
          selector       = exclusion.value.selector
        }
      }

      dynamic "override" {
        for_each = managed_rule.value.rule.overrides
        content {
          rule_group_name = override.value.rule_group_name

          dynamic "exclusion" {
            for_each = override.value.exclusions
            content {
              match_variable = exclusion.value.match_variable
              operator       = exclusion.value.operator
              selector       = exclusion.value.selector
            }
          }

          dynamic "rule" {
            for_each = override.value.rules
            content {
              rule_id = rule.value.rule_id
              action  = rule.value.action
              enabled = rule.value.enabled

              dynamic "exclusion" {
                for_each = rule.value.exclusions
                content {
                  match_variable = exclusion.value.match_variable
                  operator       = exclusion.value.operator
                  selector       = exclusion.value.selector
                }
              }
            }
          }
        }
      }
    }
  }
}
