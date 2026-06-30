# avm-res-remotebackend-oidc-wip-git-flow

This module provisions all required Azure resources for Terraform remote backend and Terraform Git Flow Automation pipeline configurations

It provisions on Azure:
- Resource group
- App Configuration (tfvars)
- Storage container (remote backend)
- DevOps Pool (agents)
- Service Connection (OIDC WIP)
- Scope specific RBAC role assignments for above resources (service principal)

Azure DevOps pipeline integration (see [pipelines folder](https://github.com/az-NCOP-motte/avm-remote-terraform-az-oidc-auth/tree/development/pipelines)):
- Generate Terraform pipeline plan on PR creation
- Apply Terraform pipeline plan on PR merge
- Agnostic multi-environment (eg. development, staging, prod1, prod2)
- Connected with the service connection
- DevOps Pool integration
- App config integration
- Simple one-time setup using Variable(s) (groups)

It will connect everything automatically:
- TFVARS pre-filled in the app config (with key vault compatibility)
- Example backend config pre-filled (for state migration)
- DevOps pools using alias

Fully modular and flexible (see [examples](https://github.com/az-NCOP-motte/avm-remote-terraform-az-oidc-auth/blob/5d6f3d05e345fde8d6aafbed9a221865ff743658/examples/complete/main.tf#L83))
- Everything optional
- Any quantity
- Resources automatically linked (eg key vault ref in app config)
- Attributes fully customizable (eg. sku_name, public_access, etc.)
