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
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_frontdoor_waf"></a> [frontdoor\_waf](#module\_frontdoor\_waf) | ./modules/frontdoor_waf | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_frontdoor.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/frontdoor) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backend_pool_health_probe_configurations"></a> [backend\_pool\_health\_probe\_configurations](#input\_backend\_pool\_health\_probe\_configurations) | The health probe configurations to pair with your backend pools | <pre>map(object({<br>    name                = string<br>    path                = string<br>    protocol            = string<br>    interval_in_seconds = number<br>  }))</pre> | n/a | yes |
| <a name="input_backend_pool_load_balancing_configurations"></a> [backend\_pool\_load\_balancing\_configurations](#input\_backend\_pool\_load\_balancing\_configurations) | The load balancing configurations to pair with your backend pools | <pre>map(object({<br>    name                            = string<br>    sample_size                     = number<br>    successful_samples_required     = number<br>    additional_latency_milliseconds = number<br>  }))</pre> | n/a | yes |
| <a name="input_backend_pools"></a> [backend\_pools](#input\_backend\_pools) | The backend pools for your front door | <pre>map(object({<br>    name                = string<br>    load_balancing_name = string<br>    health_probe_name   = string<br>    backends = map(object({<br>      enabled     = bool<br>      address     = string<br>      host_header = string<br>      http_port   = number<br>      https_port  = number<br>      priority    = number<br>      weight      = number<br>    }))<br>  }))</pre> | n/a | yes |
| <a name="input_custom_rules"></a> [custom\_rules](#input\_custom\_rules) | WAF Custom Rules | <pre>map(object({<br>    waf      = string<br>    name     = string<br>    action   = string<br>    enabled  = bool<br>    priority = number<br>    type     = string<br>    match_condition = object({<br>      match_variable     = string<br>      match_values       = list(string)<br>      operator           = string<br>      selector           = string<br>      negation_condition = bool<br>      transforms         = list(string)<br>    })<br>    rate_limit_duration_in_minutes = number<br>    rate_limit_threshold           = number<br>  }))</pre> | `{}` | no |
| <a name="input_enforce_backend_pools_certificate_name_check"></a> [enforce\_backend\_pools\_certificate\_name\_check](#input\_enforce\_backend\_pools\_certificate\_name\_check) | The flag to determine if you want to validate backend pool certificate names | `bool` | n/a | yes |
| <a name="input_forwarding_configurations"></a> [forwarding\_configurations](#input\_forwarding\_configurations) | The forwarding configuration for your routing\_rules | <pre>map(object({<br>    routing_rule_name                     = string<br>    backend_pool_name                     = string<br>    cache_enabled                         = bool<br>    cache_use_dynamic_compression         = bool<br>    cache_query_parameter_strip_directive = string<br>    custom_forwarding_path                = string<br>    forwarding_protocol                   = string<br>  }))</pre> | n/a | yes |
| <a name="input_frontdoor_friendly_name"></a> [frontdoor\_friendly\_name](#input\_frontdoor\_friendly\_name) | The friendly name of your front door | `string` | n/a | yes |
| <a name="input_frontdoor_name"></a> [frontdoor\_name](#input\_frontdoor\_name) | The name of your front door | `string` | n/a | yes |
| <a name="input_frontdoor_wafs"></a> [frontdoor\_wafs](#input\_frontdoor\_wafs) | Front Door WAF Object configuration https://www.terraform.io/docs/providers/azurerm/r/frontdoor_firewall_policy.html#argument-reference | <pre>map(object({<br>    name         = string<br>    enabled      = bool<br>    mode         = string<br>    redirect_url = string<br>  }))</pre> | `{}` | no |
| <a name="input_frontend_endpoints"></a> [frontend\_endpoints](#input\_frontend\_endpoints) | The front door endpoint resources for your front door | <pre>map(object({<br>    name                              = string<br>    host_name                         = string<br>    session_affinity_enabled          = bool<br>    session_affinity_ttl_seconds      = number<br>    custom_https_provisioning_enabled = bool<br>    custom_https_configuration = object({<br>      certificate_source = string<br>    })<br>    web_application_firewall_policy_link_name = string<br>  }))</pre> | n/a | yes |
| <a name="input_load_balancer_enabled"></a> [load\_balancer\_enabled](#input\_load\_balancer\_enabled) | The flag to determine whether or not load balancing is enabled on your front door | `string` | n/a | yes |
| <a name="input_managed_rules"></a> [managed\_rules](#input\_managed\_rules) | WAF Managed Rules | <pre>map(object({<br>    waf     = string<br>    type    = string<br>    version = string<br>    exclusions = map(object({<br>      match_variable = string<br>      operator       = string<br>      selector       = string<br>    }))<br>    overrides = map(object({<br>      rule_group_name = string<br>      exclusions = map(object({<br>        match_variable = string<br>        operator       = string<br>        selector       = string<br>      }))<br>      rules = map(object({<br>        rule_id = string<br>        action  = string<br>        enabled = bool<br>        exclusions = map(object({<br>          match_variable = string<br>          operator       = string<br>          selector       = string<br>        }))<br>      }))<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_redirect_configurations"></a> [redirect\_configurations](#input\_redirect\_configurations) | The redirect configuration for your routing\_rules | <pre>map(object({<br>    routing_rule_name   = string<br>    custom_host         = string<br>    redirect_protocol   = string<br>    redirect_type       = string<br>    custom_fragment     = string<br>    custom_path         = string<br>    custom_query_string = string<br>  }))</pre> | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource Group of the Azure Front Door to be created | `any` | n/a | yes |
| <a name="input_routing_rules"></a> [routing\_rules](#input\_routing\_rules) | The routing rules for your frontizzle | <pre>map(object({<br>    name               = string<br>    frontend_endpoints = list(string)<br>    accepted_protocols = list(string)<br>    patterns_to_match  = list(string)<br>    enabled            = bool<br>    configuration      = string<br>  }))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags of the Azure Front Door WAF Policy to be created | `map(any)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cname"></a> [cname](#output\_cname) | n/a |
| <a name="output_frontdoor"></a> [frontdoor](#output\_frontdoor) | n/a |
| <a name="output_frontdoor_waf_policy"></a> [frontdoor\_waf\_policy](#output\_frontdoor\_waf\_policy) | n/a |
| <a name="output_frontdoor_waf_policy_map"></a> [frontdoor\_waf\_policy\_map](#output\_frontdoor\_waf\_policy\_map) | n/a |
| <a name="output_frontend_endpoint_map"></a> [frontend\_endpoint\_map](#output\_frontend\_endpoint\_map) | n/a |
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Development

### Prerequisites

- [terraform](https://learn.hashicorp.com/terraform/getting-started/install#installing-terraform)
- [terraform-docs](https://github.com/segmentio/terraform-docs)
- [pre-commit](https://pre-commit.com/#install)
- [golang](https://golang.org/doc/install#install)

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
