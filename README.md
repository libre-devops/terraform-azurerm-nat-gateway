<!--
  This is the template for every Libre DevOps Terraform module. When you create a module from it:
    - replace the title, tagline, and the CI workflow / repo name in the badge URLs
    - replace the resources in main.tf, and the variables, outputs, and examples to match
    - run `just docs` (or Sort-LdoTerraform.ps1) to regenerate the section between the markers
-->
<!--
  Keep the title and badges OUTSIDE the centered <div>: the Terraform Registry's markdown renderer
  does not parse markdown inside an HTML block, so a # heading or [![badge]] in the div renders as
  literal text on the registry. Only the logo (HTML) goes in the div.
-->
<div align="center">
  <a href="https://libredevops.org">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://libredevops.org/assets/libre-devops-white.png">
      <img alt="Libre DevOps" src="https://libredevops.org/assets/libre-devops-black.png" width="300">
    </picture>
  </a>
</div>

# Terraform Azure NAT Gateway

Creates an Azure NAT gateway and its public IP, public IP prefix, and subnet associations.

[![CI](https://github.com/libre-devops/terraform-azurerm-nat-gateway/actions/workflows/ci.yml/badge.svg)](https://github.com/libre-devops/terraform-azurerm-nat-gateway/actions/workflows/ci.yml)
[![Release](https://img.shields.io/github/v/release/libre-devops/terraform-azurerm-nat-gateway?sort=semver&label=release)](https://github.com/libre-devops/terraform-azurerm-nat-gateway/releases/latest)
[![Terraform Registry](https://img.shields.io/badge/registry-libre--devops-7B42BC?logo=terraform&logoColor=white)](https://registry.terraform.io/namespaces/libre-devops)
[![License](https://img.shields.io/github/license/libre-devops/terraform-azurerm-nat-gateway)](./LICENSE)

---

## Overview

A single NAT gateway (Standard or StandardV2, optional zone) plus its associations: attach public IPs
and/or public IP prefixes for outbound, and attach it to one or more subnets. Public IPs, prefixes, and
subnets are owned by their own modules; this one **associates them by id**. Associations are keyed by a
logical name, so the ids in the values can be **computed in the same apply** without breaking `for_each`.
Composes naturally with the `public-ip` and `network`/`subnet` modules.

## Usage

```hcl
module "nat_gateway" {
  source  = "libre-devops/nat-gateway/azurerm"
  version = "~> 4.0"

  resource_group_id = module.rg.ids["rg-ldo-uks-prd-001"]
  location          = "uksouth"
  tags              = module.tags.tags

  name = "ng-ldo-uks-prd-001"

  public_ip_associations = { "pip-ldo-uks-prd-001" = module.public_ip.public_ip_ids["pip-ldo-uks-prd-001"] }
  subnet_associations    = { "snet-app-vnet-ldo-uks-prd-001" = module.network.subnet_ids["snet-app-vnet-ldo-uks-prd-001"] }
}
```

## Examples

- [`examples/minimal`](./examples/minimal) - a NAT gateway giving one subnet outbound via a public IP.
- [`examples/complete`](./examples/complete) - a zonal NAT gateway with a public IP and a prefix,
  serving multiple subnets.

## Developing

Local work needs **PowerShell 7+** and **[`just`](https://github.com/casey/just)**, because the recipes
wrap the [LibreDevOpsHelpers](https://www.powershellgallery.com/packages/LibreDevOpsHelpers)
PowerShell module (the same engine the `libre-devops/terraform-azure` action runs in CI). Install
just with `brew install just`, or `uv tool add rust-just` then `uv run just <recipe>`.

Run `just` to list recipes: `just update-ldo-pwsh` (install or force-update LibreDevOpsHelpers from
PSGallery), `just validate`, `just scan` (Trivy only), `just pwsh-analyze` (PSScriptAnalyzer only),
`just plan`, `just apply`, `just destroy`, `just e2e`, `just test`, and `just docs` (the
plan/apply/destroy recipes mirror the action, including the storage firewall dance; `just e2e`
applies an example then always destroys it, defaulting to `minimal`, so nothing is left running).
Releasing is also `just`:
`just increment-release [patch|minor|major]` bumps, tags, and publishes a GitHub release, and the
Terraform Registry picks up the tag.

## Security scan exceptions

This module is scanned with [Trivy](https://github.com/aquasecurity/trivy); HIGH and CRITICAL
findings fail the build. Any waiver is a deliberate, reviewed decision, never a way to quiet a
finding that should be fixed. Waivers live in [`.trivyignore.yaml`](./.trivyignore.yaml) (the
machine-applied source of truth, passed to Trivy with `--ignorefile`) and are mirrored in the table
below so the reason is auditable.

| Trivy ID | Resource | Finding | Justification |
|----------|----------|---------|---------------|
| _None_   |          |         |               |

To add an exception: add an entry to `.trivyignore.yaml` (`id`, optional `paths` to scope it, and a
`statement` recording why), then add a matching row here. Where the finding is out of this module's
scope, point the justification at the Libre DevOps module that does address it (for example the
private-endpoint module). Both the file and this table are reviewed in the pull request.

## Reference

The Requirements, Providers, Inputs, Outputs, and Resources below are generated by `terraform-docs`.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0, < 2.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4.0.0, < 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 4.0.0, < 5.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_nat_gateway.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway) | resource |
| [azurerm_nat_gateway_public_ip_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway_public_ip_association) | resource |
| [azurerm_nat_gateway_public_ip_prefix_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway_public_ip_prefix_association) | resource |
| [azurerm_subnet_nat_gateway_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_nat_gateway_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_idle_timeout_in_minutes"></a> [idle\_timeout\_in\_minutes](#input\_idle\_timeout\_in\_minutes) | TCP idle timeout in minutes (4 to 120). | `number` | `4` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region for the NAT gateway. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the NAT gateway. | `string` | n/a | yes |
| <a name="input_public_ip_associations"></a> [public\_ip\_associations](#input\_public\_ip\_associations) | Public IPs to attach for outbound, keyed by a logical name with the public IP id as the value (ids may be computed in the same apply; the static keys keep for\_each valid). A NAT gateway needs at least one public IP or prefix. | `map(string)` | `{}` | no |
| <a name="input_public_ip_prefix_associations"></a> [public\_ip\_prefix\_associations](#input\_public\_ip\_prefix\_associations) | Public IP prefixes to attach for outbound, keyed by a logical name with the prefix id as the value. | `map(string)` | `{}` | no |
| <a name="input_resource_group_id"></a> [resource\_group\_id](#input\_resource\_group\_id) | Resource id of the resource group to create the NAT gateway in. The name and subscription are parsed from it (pass the rg module's ids output). | `string` | n/a | yes |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | NAT gateway SKU. Standard or StandardV2. | `string` | `"Standard"` | no |
| <a name="input_subnet_associations"></a> [subnet\_associations](#input\_subnet\_associations) | Subnets to attach this NAT gateway to, keyed by subnet name with the subnet id as the value. | `map(string)` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the NAT gateway. | `map(string)` | `{}` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | Availability zones for the NAT gateway. Standard supports at most one zone; StandardV2 must omit zones (it is zone-redundant by default). | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The id of the NAT gateway. |
| <a name="output_name"></a> [name](#output\_name) | The name of the NAT gateway. |
| <a name="output_nat_gateway"></a> [nat\_gateway](#output\_nat\_gateway) | The full azurerm\_nat\_gateway resource. |
| <a name="output_public_ip_association_ids"></a> [public\_ip\_association\_ids](#output\_public\_ip\_association\_ids) | Map of logical name to public IP association id. |
| <a name="output_public_ip_prefix_association_ids"></a> [public\_ip\_prefix\_association\_ids](#output\_public\_ip\_prefix\_association\_ids) | Map of logical name to public IP prefix association id. |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Resource group name parsed from resource\_group\_id. |
| <a name="output_resource_guid"></a> [resource\_guid](#output\_resource\_guid) | The resource GUID of the NAT gateway. |
| <a name="output_subnet_association_ids"></a> [subnet\_association\_ids](#output\_subnet\_association\_ids) | Map of subnet name to subnet NAT gateway association id. |
| <a name="output_subscription_id"></a> [subscription\_id](#output\_subscription\_id) | Subscription id parsed from resource\_group\_id. |
| <a name="output_tags"></a> [tags](#output\_tags) | The tags applied to the NAT gateway. |
<!-- END_TF_DOCS -->
