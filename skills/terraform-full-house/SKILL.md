---
name: terraform-full-house
description: Generate full Terraform Azure projects using Deloitte Terraform standards and modules
---

# Terraform Full House

This skill generates a complete Terraform project for infrastructure.

Capabilities:

- Creates Terraform project structure
- Adds Terraform modules
- Creates required files:
  - main.tf
  - variables.tf
  - terraform.tfvars
  - provider.tf
  - backend.tf
  - data.tf
  - locals.tf
- Organizes modules under resources/

Modules are sourced from the Deloitte Terraform repository.

When invoked, the skill should:

1. Parse requested infrastructure
2. Map requested resources to modules
3. Create Terraform files if missing
4. Insert module blocks into main.tf
5. Place:
   - data blocks in data.tf
   - locals blocks in locals.tf
6. Add missing variables to variables.tf
7. Add values to terraform.tfvars