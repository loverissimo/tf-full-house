---
name: terraform-full-house
description: Generate full Terraform projects using Deloitte Terraform standards and modules
---

# Terraform Full House

This skill generates a complete Terraform project for Azure infrastructure.

Capabilities:

- Creates Terraform project structure
- Adds Terraform modules
- Creates required files:
  - main.tf
  - variables.tf
  - terraform.tfvars
  - provider.tf
  - backend.tf
  - locals.tf
  - data.tf
- Organizes modules under resources/
- Copies `status.md` from modules if it exists

Behavior:

1. Parse requested infrastructure from user prompt
2. Map requested resources to Deloitte Terraform modules
3. Run `scripts/fetch-module.sh <module> resources/<module>` to get module code
4. Insert module blocks into main.tf
5. Place data blocks in data.tf
6. Place locals blocks in locals.tf
7. Add missing variables to variables.tf
8. Add default values to terraform.tfvars