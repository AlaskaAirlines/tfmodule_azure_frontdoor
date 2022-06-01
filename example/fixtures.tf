locals {
  dns_zone                = "ecomm-test-aks.alaskaair.com"
  dns_resource_group_name = "ecommercekubernetes-test-group"
}

data "azurerm_dns_zone" "fixture" {
  name                = local.dns_zone
  resource_group_name = local.dns_resource_group_name
}

resource "azurerm_dns_cname_record" "fixture" {
  name                = trimsuffix(var.frontend_endpoints.fep2.host_name, ".${local.dns_zone}")
  zone_name           = data.azurerm_dns_zone.fixture.name
  resource_group_name = local.dns_resource_group_name
  ttl                 = 60
  record              = var.frontend_endpoints.fep1.host_name
}
