# tfmodule-azure-frontdoor

## Overview

Azure Front Door module
To stay up to date on our latest changes, visit our [Change Log](./docs/CHANGELOG.md).

## Usage

```hcl
module "tfmodule-azure-frontdoor" {
  source = "github.com/AlaskaAirlines/tfmodule-azure-frontdoor"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| backend\_pool\_health\_probe\_configurations | The health probe configurations to pair with your backend pools | <pre>map(object({<br>    name                = string<br>    path                = string<br>    protocol            = string<br>    interval_in_seconds = number<br>  }))</pre> | n/a | yes |
| backend\_pool\_load\_balancing\_configurations | The load balancing configurations to pair with your backend pools | <pre>map(object({<br>    name                            = string<br>    sample_size                     = number<br>    successful_samples_required     = number<br>    additional_latency_milliseconds = number<br>  }))</pre> | n/a | yes |
| backend\_pools | The backend pools for your front door | <pre>map(object({<br>    name                = string<br>    load_balancing_name = string<br>    health_probe_name   = string<br>    backends = map(object({<br>      enabled     = bool<br>      address     = string<br>      host_header = string<br>      http_port   = number<br>      https_port  = number<br>      priority    = number<br>      weight      = number<br>    }))<br>  }))</pre> | n/a | yes |
| custom\_rules | WAF Custom Rules | <pre>map(object({<br>    waf      = string<br>    name     = string<br>    action   = string<br>    enabled  = bool<br>    priority = number<br>    type     = string<br>    match_condition = object({<br>      match_variable     = string<br>      match_values       = list(string)<br>      operator           = string<br>      selector           = string<br>      negation_condition = bool<br>      transforms         = list(string)<br>    })<br>    rate_limit_duration_in_minutes = number<br>    rate_limit_threshold           = number<br>  }))</pre> | `{}` | no |
| enforce\_backend\_pools\_certificate\_name\_check | The flag to determine if you want to validate backend pool certificate names | `bool` | n/a | yes |
| forwarding\_configurations | The forwarding configuration for your routing\_rules | <pre>map(object({<br>    routing_rule_name                     = string<br>    backend_pool_name                     = string<br>    cache_enabled                         = bool<br>    cache_use_dynamic_compression         = bool<br>    cache_query_parameter_strip_directive = string<br>    custom_forwarding_path                = string<br>    forwarding_protocol                   = string<br>  }))</pre> | n/a | yes |
| frontdoor\_friendly\_name | The friendly name of your front door | `string` | n/a | yes |
| frontdoor\_name | The name of your front door | `string` | n/a | yes |
| frontdoor\_wafs | Front Door WAF Object configuration https://www.terraform.io/docs/providers/azurerm/r/frontdoor_firewall_policy.html#argument-reference | <pre>map(object({<br>    name         = string<br>    enabled      = bool<br>    mode         = string<br>    redirect_url = string<br>  }))</pre> | `{}` | no |
| frontend\_endpoints | The front door endpoint resources for your front door | <pre>map(object({<br>    name                              = string<br>    host_name                         = string<br>    session_affinity_enabled          = bool<br>    session_affinity_ttl_seconds      = number<br>    custom_https_provisioning_enabled = bool<br>    custom_https_configuration = object({<br>      certificate_source = string<br>    })<br>    web_application_firewall_policy_link_name = string<br>  }))</pre> | n/a | yes |
| load\_balancer\_enabled | The flag to determine whether or not load balancing is enabled on your front door | `string` | n/a | yes |
| managed\_rules | WAF Managed Rules | <pre>map(object({<br>    waf     = string<br>    type    = string<br>    version = string<br>    exclusions = map(object({<br>      match_variable = string<br>      operator       = string<br>      selector       = string<br>    }))<br>    overrides = map(object({<br>      rule_group_name = string<br>      exclusions = map(object({<br>        match_variable = string<br>        operator       = string<br>        selector       = string<br>      }))<br>      rules = map(object({<br>        rule_id = string<br>        action  = string<br>        enabled = bool<br>        exclusions = map(object({<br>          match_variable = string<br>          operator       = string<br>          selector       = string<br>        }))<br>      }))<br>    }))<br>  }))</pre> | `{}` | no |
| redirect\_configurations | The redirect configuration for your routing\_rules | <pre>map(object({<br>    routing_rule_name = string<br>    custom_host       = string<br>    redirect_protocol = string<br>    redirect_type     = string<br>  }))</pre> | n/a | yes |
| resource\_group\_name | Resource Group of the Azure Front Door to be created | `any` | n/a | yes |
| routing\_rules | The routing rules for your frontizzle | <pre>map(object({<br>    name               = string<br>    frontend_endpoints = list(string)<br>    accepted_protocols = list(string)<br>    patterns_to_match  = list(string)<br>    enabled            = bool<br>    configuration      = string<br>  }))</pre> | n/a | yes |
| tags | Tags of the Azure Front Door WAF Policy to be created | `map(any)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| cname | n/a |
| frontdoor | n/a |
| frontdoor\_waf\_policy | n/a |
| frontdoor\_waf\_policy\_map | n/a |
| frontend\_endpoint\_map | n/a |
| id | n/a |
| name | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Development

### Prerequisites

- [terraform](https://learn.hashicorp.com/terraform/getting-started/install#installing-terraform)
- [terraform-docs](https://github.com/segmentio/terraform-docs)
- [pre-commit](https://pre-commit.com/#install)
- [golang](https://golang.org/doc/install#install)
- [golint](https://github.com/golang/lint#installation)

### Configurations

Issue the following command

```sh
> make install
```

This will perform the following steps for you

- Initialize git repository
- Install pre-commit hooks
- Install Terraform
- Prepare testing framework

### Tests

- Tests are available in `test` directory
- In the module root directory, run the below command

```sh
make test
```

## Maintainers

Author: Shadow Quests (E-Commerce Platform Team) &lt;shadowquests@alaskaair.com&gt;

> This project was generated by [generator-aag-terraform-module](https://github.com/AlaskaAirlines/generator-aag-terraform-module)
