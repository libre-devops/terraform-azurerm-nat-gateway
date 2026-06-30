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
