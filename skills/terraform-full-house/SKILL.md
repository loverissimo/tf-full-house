---
name: terraform-full-house
description: Generate full Terraform Azure infrastructure projects using Deloitte modules
---

# Deloitte Terraform Full House

This skill generates Terraform infrastructure projects using Deloitte Azure modules.

## Capabilities

- Generate Terraform infrastructure
- Create missing Terraform files
- Use modules from the Deloitte Azure DevOps repo
- Build complete IaC projects

## Workflow

1. Parse requested infrastructure resources
2. Map resources to modules
3. Create Terraform project structure
4. Import modules
5. Generate module calls
6. Add variables and tfvars

## Project structure
.
├── main.tf
├── provider.tf
├── backend.tf
├── variables.tf
├── terraform.tfvars
└── resources/

## Example

User prompt:
Create an Azure resource group and virtual network

Output:
resources/
resource_group/
vnet/

main.tf
variables.tf
terraform.tfvars
provider.tf
backend.tf

The agent must ensure all files exist.